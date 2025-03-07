/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
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

import '@ohos/tfjs-backend-cpu';
import {expectArraysClose} from './test_util';
// tslint:disable:no-require-imports

const workerTestNode = `
// Web worker scripts in node live relative to the CWD, not to the dir of the
// file that spawned them.
const tf = require('@ohos/tfjs-core');
require('@ohos/tfjs-backend-cpu');
const {parentPort} = require('worker_threads');

let a = tf.tensor1d([1, 2, 3]);
const b = tf.tensor1d([3, 2, 1]);
a = tf.add(a, b);
parentPort.postMessage({data: a.dataSync()});
`;

describe('computation in worker (node env)', () => {
  // tslint:disable-next-line: ban
  it('tensor in worker', (done) => {
    const {Worker} = require('worker_threads');
    const worker = new Worker(workerTestNode, {eval: true});
    // tslint:disable-next-line:no-any
    worker.on('message', (msg: any) => {
      const data = msg.data;
      expectArraysClose(data, [4, 4, 4]);
      done();
    });
  });
});
