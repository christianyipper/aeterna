-- ============================================================
-- AETERNA — Seed Data
-- ============================================================

-- ── Body Regions ─────────────────────────────────────────────

insert into body_regions (region_key, label, side, category) values
  -- Upper Body
  ('neck',            'Neck',             'center', 'upper_body'),
  ('left_shoulder',   'Left Shoulder',    'left',   'upper_body'),
  ('right_shoulder',  'Right Shoulder',   'right',  'upper_body'),
  ('left_elbow',      'Left Elbow',       'left',   'upper_body'),
  ('right_elbow',     'Right Elbow',      'right',  'upper_body'),
  ('left_wrist',      'Left Wrist',       'left',   'upper_body'),
  ('right_wrist',     'Right Wrist',      'right',  'upper_body'),
  ('chest',           'Chest',            'center', 'upper_body'),
  ('upper_back',      'Upper Back',       'center', 'upper_body'),
  ('lower_back',      'Lower Back',       'center', 'upper_body'),
  -- Core
  ('abs',             'Abs',              'center', 'core'),
  ('left_oblique',    'Left Oblique',     'left',   'core'),
  ('right_oblique',   'Right Oblique',    'right',  'core'),
  -- Lower Body
  ('left_hip',        'Left Hip',         'left',   'lower_body'),
  ('right_hip',       'Right Hip',        'right',  'lower_body'),
  ('left_glute',      'Left Glute',       'left',   'lower_body'),
  ('right_glute',     'Right Glute',      'right',  'lower_body'),
  ('left_quad',       'Left Quad',        'left',   'lower_body'),
  ('right_quad',      'Right Quad',       'right',  'lower_body'),
  ('left_hamstring',  'Left Hamstring',   'left',   'lower_body'),
  ('right_hamstring', 'Right Hamstring',  'right',  'lower_body'),
  ('left_knee',       'Left Knee',        'left',   'lower_body'),
  ('right_knee',      'Right Knee',       'right',  'lower_body'),
  ('left_calf',       'Left Calf',        'left',   'lower_body'),
  ('right_calf',      'Right Calf',       'right',  'lower_body'),
  ('left_ankle',      'Left Ankle',       'left',   'lower_body'),
  ('right_ankle',     'Right Ankle',      'right',  'lower_body');

-- ── Prep Protocol Exercises ───────────────────────────────────

insert into exercises (id, name, category, muscle_groups, is_prep_protocol, default_sets, default_reps, default_weight_kg) values
  -- Neck
  ('00000000-0000-0000-0000-000000000001', 'Neck CARs',                'prep', '{neck}',                         true, 1, 5,  null),
  -- Shoulder
  ('00000000-0000-0000-0000-000000000002', 'Shoulder CARs',            'prep', '{left_shoulder,right_shoulder}', true, 1, 5,  null),
  ('00000000-0000-0000-0000-000000000003', 'Band Pull-Aparts',         'prep', '{upper_back,left_shoulder,right_shoulder}', true, 2, 15, null),
  -- Elbow / Wrist
  ('00000000-0000-0000-0000-000000000004', 'Wrist Rotations',          'prep', '{left_wrist,right_wrist}',       true, 1, 10, null),
  ('00000000-0000-0000-0000-000000000005', 'Elbow Flexion/Extension',  'prep', '{left_elbow,right_elbow}',       true, 1, 10, null),
  -- Chest / Upper Back
  ('00000000-0000-0000-0000-000000000006', 'Thoracic Rotation',        'prep', '{upper_back,chest}',             true, 1, 8,  null),
  ('00000000-0000-0000-0000-000000000007', 'Cat-Cow',                  'prep', '{upper_back,lower_back}',        true, 1, 10, null),
  -- Lower Back
  ('00000000-0000-0000-0000-000000000008', 'Dead Bug',                 'prep', '{lower_back,abs}',               true, 2, 8,  null),
  ('00000000-0000-0000-0000-000000000009', 'McGill Big 3 – Bird Dog',  'prep', '{lower_back}',                   true, 1, 10, null),
  -- Core
  ('00000000-0000-0000-0000-000000000010', 'Pallof Press',             'prep', '{abs,left_oblique,right_oblique}', true, 2, 10, null),
  -- Hip
  ('00000000-0000-0000-0000-000000000011', 'Hip 90/90 Stretch',        'prep', '{left_hip,right_hip}',           true, 1, 5,  null),
  ('00000000-0000-0000-0000-000000000012', 'Hip CARs',                 'prep', '{left_hip,right_hip}',           true, 1, 5,  null),
  -- Glute
  ('00000000-0000-0000-0000-000000000013', 'Glute Bridges',            'prep', '{left_glute,right_glute}',       true, 2, 12, null),
  -- Quad / Hamstring
  ('00000000-0000-0000-0000-000000000014', 'Leg Swings',               'prep', '{left_quad,right_quad,left_hamstring,right_hamstring}', true, 1, 10, null),
  ('00000000-0000-0000-0000-000000000015', 'Nordic Hamstring Lowering','prep', '{left_hamstring,right_hamstring}', true, 2, 5,  null),
  -- Knee
  ('00000000-0000-0000-0000-000000000016', 'Terminal Knee Extensions', 'prep', '{left_knee,right_knee}',         true, 2, 15, null),
  ('00000000-0000-0000-0000-000000000017', 'Step-Ups (light)',         'prep', '{left_knee,right_knee,left_quad,right_quad}', true, 2, 10, null),
  -- Calf / Ankle
  ('00000000-0000-0000-0000-000000000018', 'Ankle CARs',               'prep', '{left_ankle,right_ankle}',       true, 1, 8,  null),
  ('00000000-0000-0000-0000-000000000019', 'Calf Raises (eccentric)',  'prep', '{left_calf,right_calf}',         true, 2, 10, null);

-- ── Friction Rules ────────────────────────────────────────────
-- friction_threshold 1 = moderate stiffness → inject mobility/prep
-- friction_threshold 2 = sore/tight        → inject + apply load ceiling

insert into friction_rules (region_key, friction_threshold, action_type, exercise_id, load_ceiling_pct) values
  -- Neck
  ('neck', 1, 'inject_exercise', '00000000-0000-0000-0000-000000000001', null),
  ('neck', 2, 'inject_exercise', '00000000-0000-0000-0000-000000000001', null),
  ('neck', 2, 'load_ceiling',    null, 0.80),

  -- Shoulders
  ('left_shoulder',  1, 'inject_exercise', '00000000-0000-0000-0000-000000000002', null),
  ('left_shoulder',  2, 'inject_exercise', '00000000-0000-0000-0000-000000000002', null),
  ('left_shoulder',  2, 'inject_exercise', '00000000-0000-0000-0000-000000000003', null),
  ('left_shoulder',  2, 'load_ceiling',    null, 0.75),
  ('right_shoulder', 1, 'inject_exercise', '00000000-0000-0000-0000-000000000002', null),
  ('right_shoulder', 2, 'inject_exercise', '00000000-0000-0000-0000-000000000002', null),
  ('right_shoulder', 2, 'inject_exercise', '00000000-0000-0000-0000-000000000003', null),
  ('right_shoulder', 2, 'load_ceiling',    null, 0.75),

  -- Elbows
  ('left_elbow',  1, 'inject_exercise', '00000000-0000-0000-0000-000000000005', null),
  ('left_elbow',  2, 'inject_exercise', '00000000-0000-0000-0000-000000000005', null),
  ('left_elbow',  2, 'load_ceiling',    null, 0.80),
  ('right_elbow', 1, 'inject_exercise', '00000000-0000-0000-0000-000000000005', null),
  ('right_elbow', 2, 'inject_exercise', '00000000-0000-0000-0000-000000000005', null),
  ('right_elbow', 2, 'load_ceiling',    null, 0.80),

  -- Wrists
  ('left_wrist',  1, 'inject_exercise', '00000000-0000-0000-0000-000000000004', null),
  ('left_wrist',  2, 'inject_exercise', '00000000-0000-0000-0000-000000000004', null),
  ('left_wrist',  2, 'load_ceiling',    null, 0.80),
  ('right_wrist', 1, 'inject_exercise', '00000000-0000-0000-0000-000000000004', null),
  ('right_wrist', 2, 'inject_exercise', '00000000-0000-0000-0000-000000000004', null),
  ('right_wrist', 2, 'load_ceiling',    null, 0.80),

  -- Chest / Upper Back
  ('chest',      1, 'inject_exercise', '00000000-0000-0000-0000-000000000006', null),
  ('chest',      2, 'inject_exercise', '00000000-0000-0000-0000-000000000006', null),
  ('chest',      2, 'load_ceiling',    null, 0.80),
  ('upper_back', 1, 'inject_exercise', '00000000-0000-0000-0000-000000000006', null),
  ('upper_back', 2, 'inject_exercise', '00000000-0000-0000-0000-000000000007', null),
  ('upper_back', 2, 'load_ceiling',    null, 0.80),

  -- Lower Back
  ('lower_back', 1, 'inject_exercise', '00000000-0000-0000-0000-000000000007', null),
  ('lower_back', 2, 'inject_exercise', '00000000-0000-0000-0000-000000000008', null),
  ('lower_back', 2, 'inject_exercise', '00000000-0000-0000-0000-000000000009', null),
  ('lower_back', 2, 'load_ceiling',    null, 0.70),

  -- Core
  ('abs',           1, 'inject_exercise', '00000000-0000-0000-0000-000000000010', null),
  ('abs',           2, 'inject_exercise', '00000000-0000-0000-0000-000000000010', null),
  ('left_oblique',  1, 'inject_exercise', '00000000-0000-0000-0000-000000000010', null),
  ('left_oblique',  2, 'inject_exercise', '00000000-0000-0000-0000-000000000010', null),
  ('right_oblique', 1, 'inject_exercise', '00000000-0000-0000-0000-000000000010', null),
  ('right_oblique', 2, 'inject_exercise', '00000000-0000-0000-0000-000000000010', null),

  -- Hips
  ('left_hip',  1, 'inject_exercise', '00000000-0000-0000-0000-000000000011', null),
  ('left_hip',  2, 'inject_exercise', '00000000-0000-0000-0000-000000000012', null),
  ('left_hip',  2, 'load_ceiling',    null, 0.80),
  ('right_hip', 1, 'inject_exercise', '00000000-0000-0000-0000-000000000011', null),
  ('right_hip', 2, 'inject_exercise', '00000000-0000-0000-0000-000000000012', null),
  ('right_hip', 2, 'load_ceiling',    null, 0.80),

  -- Glutes
  ('left_glute',  1, 'inject_exercise', '00000000-0000-0000-0000-000000000013', null),
  ('left_glute',  2, 'inject_exercise', '00000000-0000-0000-0000-000000000013', null),
  ('left_glute',  2, 'load_ceiling',    null, 0.85),
  ('right_glute', 1, 'inject_exercise', '00000000-0000-0000-0000-000000000013', null),
  ('right_glute', 2, 'inject_exercise', '00000000-0000-0000-0000-000000000013', null),
  ('right_glute', 2, 'load_ceiling',    null, 0.85),

  -- Quads
  ('left_quad',  1, 'inject_exercise', '00000000-0000-0000-0000-000000000014', null),
  ('left_quad',  2, 'inject_exercise', '00000000-0000-0000-0000-000000000014', null),
  ('left_quad',  2, 'load_ceiling',    null, 0.80),
  ('right_quad', 1, 'inject_exercise', '00000000-0000-0000-0000-000000000014', null),
  ('right_quad', 2, 'inject_exercise', '00000000-0000-0000-0000-000000000014', null),
  ('right_quad', 2, 'load_ceiling',    null, 0.80),

  -- Hamstrings
  ('left_hamstring',  1, 'inject_exercise', '00000000-0000-0000-0000-000000000014', null),
  ('left_hamstring',  2, 'inject_exercise', '00000000-0000-0000-0000-000000000015', null),
  ('left_hamstring',  2, 'load_ceiling',    null, 0.80),
  ('right_hamstring', 1, 'inject_exercise', '00000000-0000-0000-0000-000000000014', null),
  ('right_hamstring', 2, 'inject_exercise', '00000000-0000-0000-0000-000000000015', null),
  ('right_hamstring', 2, 'load_ceiling',    null, 0.80),

  -- Knees
  ('left_knee',  1, 'inject_exercise', '00000000-0000-0000-0000-000000000016', null),
  ('left_knee',  2, 'inject_exercise', '00000000-0000-0000-0000-000000000017', null),
  ('left_knee',  2, 'load_ceiling',    null, 0.75),
  ('right_knee', 1, 'inject_exercise', '00000000-0000-0000-0000-000000000016', null),
  ('right_knee', 2, 'inject_exercise', '00000000-0000-0000-0000-000000000017', null),
  ('right_knee', 2, 'load_ceiling',    null, 0.75),

  -- Calves
  ('left_calf',  1, 'inject_exercise', '00000000-0000-0000-0000-000000000019', null),
  ('left_calf',  2, 'inject_exercise', '00000000-0000-0000-0000-000000000019', null),
  ('left_calf',  2, 'load_ceiling',    null, 0.85),
  ('right_calf', 1, 'inject_exercise', '00000000-0000-0000-0000-000000000019', null),
  ('right_calf', 2, 'inject_exercise', '00000000-0000-0000-0000-000000000019', null),
  ('right_calf', 2, 'load_ceiling',    null, 0.85),

  -- Ankles
  ('left_ankle',  1, 'inject_exercise', '00000000-0000-0000-0000-000000000018', null),
  ('left_ankle',  2, 'inject_exercise', '00000000-0000-0000-0000-000000000018', null),
  ('left_ankle',  2, 'load_ceiling',    null, 0.85),
  ('right_ankle', 1, 'inject_exercise', '00000000-0000-0000-0000-000000000018', null),
  ('right_ankle', 2, 'inject_exercise', '00000000-0000-0000-0000-000000000018', null),
  ('right_ankle', 2, 'load_ceiling',    null, 0.85);
