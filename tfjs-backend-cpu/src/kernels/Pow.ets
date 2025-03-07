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

import {KernelConfig, Pow} from '@ohos/tfjs-core';

import {createSimpleBinaryKernelImpl} from '../utils/binary_impl';
import {binaryKernelFunc} from '../utils/binary_utils';

export const powImpl =
    createSimpleBinaryKernelImpl((a: number, b: number) => Math.pow(a, b));
export const pow = binaryKernelFunc(Pow, powImpl);

export const powConfig: KernelConfig = {
  kernelName: Pow,
  backendName: 'cpu',
  kernelFunc: pow
};
