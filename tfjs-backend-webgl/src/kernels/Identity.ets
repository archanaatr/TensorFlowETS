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

import {Identity, IdentityInputs, KernelConfig, KernelFunc, TensorInfo} from '@ohos/tfjs-core';

import {MathBackendWebGL} from '../backend_webgl';

export function identity(
    args: {inputs: IdentityInputs, backend: MathBackendWebGL}): TensorInfo {
  const {inputs, backend} = args;
  const {x} = inputs;

  backend.incRef(x.dataId);

  return {dataId: x.dataId, shape: x.shape, dtype: x.dtype};
}

export const identityConfig: KernelConfig = {
  kernelName: Identity,
  backendName: 'webgl',
  kernelFunc: identity as {} as KernelFunc
};
