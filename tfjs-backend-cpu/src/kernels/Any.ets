/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */

import {Any, AnyAttrs, AnyInputs, backend_util, KernelConfig, KernelFunc, TensorInfo, TypedArray, util} from '@ohos/tfjs-core';

import {MathBackendCPU} from '../backend_cpu';
import {assertNotComplex} from '../cpu_util';
import {reshape} from './Reshape';
import {transpose} from './Transpose';

export function any(
    args: {inputs: AnyInputs, backend: MathBackendCPU, attrs: AnyAttrs}):
    TensorInfo {
  const {inputs, backend, attrs} = args;
  const {x} = inputs;
  const {axis, keepDims} = attrs;

  assertNotComplex(x, 'any');

  const origAxes = util.parseAxisParam(axis, x.shape);
  let axes = origAxes;
  const permutedAxes = backend_util.getAxesPermutation(axes, x.shape.length);
  let $x = x;
  if (permutedAxes != null) {
    $x = transpose({inputs: {x}, backend, attrs: {perm: permutedAxes}});
    axes = backend_util.getInnerMostAxes(axes.length, x.shape.length);
  }

  backend_util.assertAxesAreInnerMostDims('any', axes, $x.shape.length);
  const [outShape, reduceShape] =
      backend_util.computeOutAndReduceShapes($x.shape, axes);
  const reduceSize = util.sizeFromShape(reduceShape);
  const vals = util.makeZerosTypedArray(util.sizeFromShape(outShape), $x.dtype);

  const aVals = backend.data.get($x.dataId).values as TypedArray;
  for (let i = 0; i < vals.length; ++i) {
    const offset = i * reduceSize;
    let anyVal = aVals[offset];
    for (let j = 0; j < reduceSize; ++j) {
      const value = aVals[offset + j];
      anyVal = anyVal || value;
    }
    vals[i] = anyVal;
  }

  if (permutedAxes != null) {
    backend.disposeIntermediateTensorInfo($x);
  }

  const result = backend.makeTensorInfo(outShape, $x.dtype, vals);

  if (keepDims) {
    const expandedShape = backend_util.expandShapeToKeepDim(outShape, origAxes);
    const reshapedResult =
        reshape({inputs: {x: result}, backend, attrs: {shape: expandedShape}});

    backend.disposeIntermediateTensorInfo(result);

    return reshapedResult;
  }

  return result;
}

export const anyConfig: KernelConfig = {
  kernelName: Any,
  backendName: 'cpu',
  kernelFunc: any as {} as KernelFunc
};
