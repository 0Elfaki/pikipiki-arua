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
