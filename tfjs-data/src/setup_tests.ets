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

import '@ohos/tfjs-core';
// tslint:disable-next-line:no-imports-from-dist
import '@ohos/tfjs-core/dist/public/chained_ops/register_all_chained_ops';
import '@ohos/tfjs-backend-cpu';
import '@ohos/tfjs-backend-webgl';

// Import and run tests from data.
// tslint:disable-next-line:no-require-imports
require('./tests');
