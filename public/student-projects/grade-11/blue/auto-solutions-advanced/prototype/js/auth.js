/* ==========================================================================
   AUTO-SOLUTIONS - Authentication & Role Manager
   ========================================================================== */

class AuthManager {
  constructor() {
    this.currentUser = JSON.parse(localStorage.getItem('auto_solutions_user')) || {
      name: "Estudiante de Ingeniería",
      role: "Ingeniero de Software",
      team: "Equipo #1 AUTO-SOLUTIONS",
      grade: "11° Blue",
      isLoggedIn: true
    };
  }

  getCurrentUser() {
    return this.currentUser;
  }

  login(name, role, grade) {
    this.currentUser = {
      name: name || "Usuario STEM",
      role: role || "Estudiante",
      team: "Equipo de Robótica",
      grade: grade || "11°",
      isLoggedIn: true
    };
    localStorage.setItem('auto_solutions_user', JSON.stringify(this.currentUser));
    this.updateUI();
  }

  logout() {
    this.currentUser = {
      name: "Invitado",
      role: "Visitante Feria STEM",
      team: "Sin asignar",
      grade: "N/A",
      isLoggedIn: false
    };
    localStorage.removeItem('auto_solutions_user');
    this.updateUI();
  }

  updateUI() {
    const userNameElem = document.getElementById('user-name-display');
    const userRoleElem = document.getElementById('user-role-display');

    if (userNameElem) userNameElem.textContent = this.currentUser.name;
    if (userRoleElem) userRoleElem.textContent = `${this.currentUser.role} (${this.currentUser.grade})`;
  }
}

window.auth = new AuthManager();
