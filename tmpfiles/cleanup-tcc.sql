INSERT INTO
  access
VALUES
  (
    'kTCCServiceSystemPolicyDownloadsFolder', -- service
    '/usr/local/bin/cleanup.sh', -- client
    1, -- client_type (1 - absolute path)
    2, -- auth_value  (2 - allowed)
    3, -- auth_reason (3 - "User Set")
    1, -- auth_version
    -- csreq
    X'fade0c0100000040000000010000000100000014fade0c000000002c0000000100000006000000020000000d636f6d2e6170706c652e656e7600000000000003',
    NULL, -- policy_id
    NULL, -- indirect_object_identifier_type
    'UNUSED', -- indirect_object_identifier
    NULL, -- indirect_object_code_identity
    0, -- flags
    1612407199 -- last_updated
  );
