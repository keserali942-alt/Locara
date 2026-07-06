// Supabase Edge Function: ai-tagging

// @ts-ignore Deno global is provided by Supabase Edge Runtime.
Deno.serve(async (_req: Request): Promise<Response> => {
  return new Response(JSON.stringify({ status: 'ok' }), {
    status: 200,
    headers: { 'Content-Type': 'application/json' },
  });
});
