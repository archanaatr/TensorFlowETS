/**
 * @license
 * Copyright 2020 Google LLC. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the License);
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an AS IS BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =============================================================================
 */

import {KernelConfig, Round} from '@ohos/tfjs-core';

import {unaryKernelFunc} from '../utils/unary_utils';

export const round = unaryKernelFunc(Round, (xi) => {
  // The algorithm is based on banker's rounding.
  const base = Math.floor(xi);
  if (xi - base < 0.5) {
    return Math.floor(xi);
  } else if (xi - base > 0.5) {
    return Math.ceil(xi);
  } else {
    if (base % 2.0 === 0.0) {
      return base;
    } else {
      return base + 1.0;
    }
  }
});

export const roundConfig: KernelConfig = {
  kernelName: Round,
  backendName: 'cpu',
  kernelFunc: round,
};
