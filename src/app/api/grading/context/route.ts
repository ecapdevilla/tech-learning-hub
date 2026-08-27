import { NextRequest, NextResponse } from "next/server";
import { gradingRepository } from "@/modules/grading/data/gradingRepository";
import { TEACHER_COOKIE } from "@/app/api/self-assessment/teacher-login/route";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest) {
  const teacher = request.cookies.get(TEACHER_COOKIE)?.value;
  if (teacher !== "authorized") {
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  }
  const subjects = await gradingRepository.getSubjects();
  const periods = await gradingRepository.getPeriods();
  return NextResponse.json({ subjects, periods });
}