// Supabase Edge Function: place-provider
// Proxies external place APIs. Keep API keys only in function secrets.

// @ts-ignore Deno global is provided by Supabase Edge Runtime.
Deno.serve(async (req: Request): Promise<Response> => {
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'Method not allowed' }), {
      status: 405,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  const payload = await req.json().catch(() => null);
  if (!payload) {
    return new Response(JSON.stringify({ error: 'Invalid JSON body' }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  const lat = Number(payload.lat);
  const lng = Number(payload.lng);
  const radius = Number(payload.radius ?? 1000);

  if (Number.isNaN(lat) || Number.isNaN(lng)) {
    return new Response(JSON.stringify({ error: 'lat and lng are required' }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  // Placeholder response for Phase 0. Real provider integration starts in later phases.
  const sample = [
    {
      id: 'sample-1',
      name: 'Sample Place',
      latitude: lat,
      longitude: lng,
      radius,
    },
  ];

  return new Response(JSON.stringify(sample), {
    status: 200,
    headers: { 'Content-Type': 'application/json' },
  });
});
