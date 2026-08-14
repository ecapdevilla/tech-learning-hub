import type { StudentProject } from "@/modules/student-projects/types/studentProject";

function getDownloadName(project: StudentProject) {
  const safeTitle = project.slug || `grade-${project.grade}-project`;
  return `${safeTitle}.html`;
}

export function ProjectCard({ project }: { project: StudentProject }) {
  return (
    <article className="student-project-card">
      <div className="student-project-cover">
        <span className="student-project-cover-icon">🚀</span>
        <div>
          <small>STUDENT CREATION</small>
          <strong>{project.grade}th Grade · {project.classroom.toUpperCase()}</strong>
        </div>
      </div>

      <div className="student-project-content">
        <div className="student-project-meta">
          <span>Cycle {project.cycle}</span>
          <span>Period {project.period}</span>
        </div>

        <small className="student-project-tech">{project.technologies.join(" · ")}</small>
        <h3>{project.title}</h3>
        <p>{project.description}</p>

        <div className="student-authors">
          <span>👩‍💻</span>
          <div>
            <small>CREATED BY</small>
            <b>{project.studentName}</b>
          </div>
        </div>

        <div className="project-skills">
          {project.skills.map((skill) => <span key={skill}>{skill}</span>)}
        </div>

        {project.projectPath && (
          <div className="student-project-actions">
            <a className="student-project-open" href={project.projectPath}>
              EXPLORE PROJECT <span>→</span>
            </a>

            <a
              className="student-project-download"
              href={project.projectPath}
              download={getDownloadName(project)}
              title="Download an editable HTML copy of this student project"
            >
              ⬇ DOWNLOAD HTML
            </a>
          </div>
        )}
      </div>
    </article>
  );
}