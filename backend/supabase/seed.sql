-- ==============================================================================
-- Pikipiki Arua: Seed Data (Arua City Stages, Locations & Demo Data)
-- ==============================================================================

-- 1. Insert Arua Boda Stages
INSERT INTO public.boda_stages (id, name, code, chairman_name, chairman_phone, latitude, longitude)
VALUES
    (
        'a1111111-1111-1111-1111-111111111111',
        'Arua Main Market Stage',
        'STAGE-MKT-01',
        'Bakole Juma',
        '+256772112233',
        3.0298,
        30.9102
    ),
    (
        'a2222222-2222-2222-2222-222222222222',
        'Arua Hill Roundabout Stage',
        'STAGE-HILL-02',
        'Droma Richard',
        '+256782445566',
        3.0315,
        30.9065
    ),
    (
        'a3333333-3333-3333-3333-333333333333',
        'Muni University Gate Stage',
        'STAGE-MUNI-03',
        'Afema Charles',
        '+256701889900',
        3.0112,
        30.9189
    ),
    (
        'a4444444-4444-4444-4444-444444444444',
        'Arua Regional Referral Hospital Stage',
        'STAGE-HOSP-04',
        'Angua Francis',
        '+256752334455',
        3.0275,
        30.9040
    ),
    (
        'a5555555-5555-5555-5555-555555555555',
        'Onduparaka Trading Center Stage',
        'STAGE-ONDU-05',
        'Candia Moses',
        '+256774991122',
        3.0450,
        30.8920
    ),
    (
        'a6666666-6666-6666-6666-666666666666',
        'Ediofe Cathedral Junction Stage',
        'STAGE-EDIO-06',
        'Ondoma Peter',
        '+256783223344',
        3.0380,
        30.8995
    )
ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- Demo Drivers (for local development & dispatch-engine testing)
-- ==============================================================================
-- These give the matching engine real, online, verified drivers to match
-- against before driver phone-OTP auth is wired up in the driver app (which
-- currently runs in a fixed demo-identity mode). The first driver's id/phone/
-- name/plate match the driver app's hardcoded demo profile, so "Demo Boda
-- Operator Mode" in the driver app maps to a real row here.
--
-- Inserting directly into auth.users is only safe for local/dev seeding, and
-- is wrapped below so a schema difference in your Supabase CLI/GoTrue version
-- doesn't block the rest of this seed file (in that case you'll see a NOTICE
-- and can create these three test accounts through Supabase Auth instead).
DO $$
BEGIN
    INSERT INTO auth.users (
        id, instance_id, aud, role, phone, phone_confirmed_at,
        raw_app_meta_data, raw_user_meta_data, created_at, updated_at
    ) VALUES
        ('d0000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', '+256772445566', NOW(), '{"provider":"phone","providers":["phone"]}', '{}', NOW(), NOW()),
        ('d0000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', '+256701223344', NOW(), '{"provider":"phone","providers":["phone"]}', '{}', NOW(), NOW()),
        ('d0000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', '+256783556677', NOW(), '{"provider":"phone","providers":["phone"]}', '{}', NOW(), NOW())
    ON CONFLICT (id) DO NOTHING;

    INSERT INTO public.profiles (id, phone_number, full_name, role, rating)
    VALUES
        ('d0000000-0000-0000-0000-000000000001', '+256772445566', 'Juma Bosco Ondoma', 'driver', 4.92),
        ('d0000000-0000-0000-0000-000000000002', '+256701223344', 'Ayikoru Sarah', 'driver', 4.85),
        ('d0000000-0000-0000-0000-000000000003', '+256783556677', 'Drametu Emmanuel', 'driver', 4.78)
    ON CONFLICT (id) DO NOTHING;

    INSERT INTO public.drivers (
        id, stage_id, number_plate, motorcycle_make_model, is_online,
        current_latitude, current_longitude, verification_status
    ) VALUES
        ('d0000000-0000-0000-0000-000000000001', 'a2222222-2222-2222-2222-222222222222', 'UFL 492X', 'Bajaj Boxer 100', TRUE, 3.0316, 30.9066, 'verified'),
        ('d0000000-0000-0000-0000-000000000002', 'a3333333-3333-3333-3333-333333333333', 'UFP 118K', 'TVS HLX 125', TRUE, 3.0110, 30.9185, 'verified'),
        ('d0000000-0000-0000-0000-000000000003', 'a5555555-5555-5555-5555-555555555555', 'UEC 774B', 'Bajaj Boxer 100', TRUE, 3.0448, 30.8925, 'verified')
    ON CONFLICT (id) DO NOTHING;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Skipped demo driver seed (auth.users schema mismatch on this Supabase version?): %', SQLERRM;
END $$;
