import { NextRequest, NextResponse } from "next/server";
import { SELF_ASSESSMENT_TEACHER_PASSWORD } from "@/modules/self-assessment/types/selfAssessment";

export const TEACHER_COOKIE = "self_assessment_teacher";
const COOKIE_MAX_AGE = 60 * 60 * 8; // 8 horas

export async function POST(request: NextRequest) {
  let body: { password?: string } = {};
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ ok: false }, { status: 400 });
  }

  const password = body.password ?? "";
  if (password !== SELF_ASSESSMENT_TEACHER_PASSWORD) {
    return NextResponse.json({ ok: false, error: "invalid" }, { status: 401 });
  }

  const response = NextResponse.json({ ok: true });
  response.cookies.set(TEACHER_COOKIE, "authorized", {
    httpOnly: true,
    sameSite: "lax",
    secure: process.env.NODE_ENV === "production",
    path: "/",
    maxAge: COOKIE_MAX_AGE,
  });
  return response;
}

export async function DELETE() {
  const response = NextResponse.json({ ok: true });
  response.cookies.set(TEACHER_COOKIE, "", {
    httpOnly: true,
    path: "/",
    maxAge: 0,
  });
  return response;
}