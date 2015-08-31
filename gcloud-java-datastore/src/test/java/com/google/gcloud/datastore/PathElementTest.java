/*
 * Copyright 2015 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.gcloud.datastore;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

public class PathElementTest {

  private static final PathElement PE_1 = PathElement.of("k1");
  private static final PathElement PE_2 = PathElement.of("k2", "n");
  private static final PathElement PE_3 = PathElement.of("k3", 1);

  @Test
  public void testKind() throws Exception {
    assertEquals("k1", PE_1.kind());
    assertEquals("k2", PE_2.kind());
    assertEquals("k3", PE_3.kind());
  }

  @Test
  public void testHasId() throws Exception {
    assertFalse(PE_1.hasId());
    assertFalse(PE_2.hasId());
    assertTrue(PE_3.hasId());
  }

  @Test
  public void testId() throws Exception {
    assertNull(PE_1.id());
    assertNull(PE_2.id());
    assertEquals(Long.valueOf(1), PE_3.id());
  }

  @Test
  public void testHasName() throws Exception {
    assertFalse(PE_1.hasName());
    assertTrue(PE_2.hasName());
    assertFalse(PE_3.hasName());
  }

  @Test
  public void testName() throws Exception {
    assertNull(PE_1.name());
    assertEquals("n", PE_2.name());
    assertNull(PE_3.name());
  }

  @Test
  public void testNameOrId() throws Exception {
    assertNull(PE_1.nameOrId());
    assertEquals("n", PE_2.nameOrId());
    assertEquals(Long.valueOf(1), PE_3.nameOrId());
  }
}
