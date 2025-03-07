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

import {KernelConfig, Sigmoid} from '@ohos/tfjs-core';

import {CHECK_NAN_SNIPPET_UNARY, unaryKernelFunc} from '../kernel_utils/kernel_funcs_utils';
import {sigmoidImplCPU} from '../kernel_utils/shared';

const SIGMOID = CHECK_NAN_SNIPPET_UNARY + `
  return 1.0 / (1.0 + exp(-1.0 * x));
`;

const SIGMOID_PACKED = `
  vec4 result = 1.0 / (1.0 + exp(-1.0 * x));
  bvec4 isNaN = isnan(x);

  result.r = isNaN.r ? x.r : result.r;
  result.g = isNaN.g ? x.g : result.g;
  result.b = isNaN.b ? x.b : result.b;
  result.a = isNaN.a ? x.a : result.a;

  return result;
`;
export const sigmoid = unaryKernelFunc({
  opSnippet: SIGMOID,
  packedOpSnippet: SIGMOID_PACKED,
  cpuKernelImpl: sigmoidImplCPU
});

export const sigmoidConfig: KernelConfig = {
  kernelName: Sigmoid,
  backendName: 'webgl',
  kernelFunc: sigmoid,
};
