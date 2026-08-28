// AS DesignTech — navigation, scroll effects, PWA
document.addEventListener("DOMContentLoaded", () => {
  initNavigation();
  initScrollReveal();
  initScrollSpy();
  initBackToTop();
  initServiceWorker();
  initInstallPrompt();
  initFlashBar();
});

function initNavigation() {
  const menuBtn = document.querySelector(".menu-btn");
  const navLinks = document.querySelector(".nav-links");
  const navWrap = document.querySelector("[data-nav]");

  menuBtn?.addEventListener("click", () => {
    const isOpen = navLinks?.classList.toggle("open");
    menuBtn.setAttribute("aria-expanded", isOpen ? "true" : "false");
    menuBtn.setAttribute("aria-label", isOpen ? "Close menu" : "Open menu");
    document.body.classList.toggle("menu-open", Boolean(isOpen));
  });

  const closeMenu = () => {
    navLinks?.classList.remove("open");
    menuBtn?.setAttribute("aria-expanded", "false");
    menuBtn?.setAttribute("aria-label", "Open menu");
    document.body.classList.remove("menu-open");
  };

  document.querySelectorAll(".nav-links a, .footer-links a").forEach((link) => {
    link.addEventListener("click", closeMenu);
  });

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") closeMenu();
  });

  window.addEventListener("scroll", () => {
    navWrap?.classList.toggle("is-scrolled", window.scrollY > 20);
  }, { passive: true });
}

function initScrollReveal() {
  const prefersReduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  const elements = document.querySelectorAll(".reveal");
  if (prefersReduced || !elements.length) {
    elements.forEach((el) => el.classList.add("is-visible"));
    return;
  }

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-visible");
          observer.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.12, rootMargin: "0px 0px -40px 0px" }
  );

  elements.forEach((el) => observer.observe(el));
}

function initScrollSpy() {
  const sections = document.querySelectorAll("main section[id]");
  const navLinks = document.querySelectorAll("[data-nav-link]");
  if (!sections.length || !navLinks.length) return;

  const linkMap = new Map(
    [...navLinks].map((link) => [link.getAttribute("href")?.slice(1), link])
  );

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          const id = entry.target.id;
          navLinks.forEach((link) => link.classList.remove("is-active"));
          linkMap.get(id)?.classList.add("is-active");
        }
      });
    },
    { rootMargin: "-40% 0px -55% 0px", threshold: 0 }
  );

  sections.forEach((section) => observer.observe(section));
}

function initBackToTop() {
  const button = document.querySelector(".back-top");
  if (!button) return;

  window.addEventListener("scroll", () => {
    button.hidden = window.scrollY < 400;
  }, { passive: true });

  button.addEventListener("click", () => {
    window.scrollTo({ top: 0, behavior: "smooth" });
  });
}

function initServiceWorker() {
  if (!("serviceWorker" in navigator)) return;

  window.addEventListener("load", () => {
    navigator.serviceWorker.register("/service-worker", { scope: "/" }).catch(() => {});
  });
}

function initInstallPrompt() {
  const banner = document.querySelector(".install-banner");
  const installBtn = document.querySelector(".install-btn");
  const dismissBtn = document.querySelector(".install-dismiss");
  if (!banner) return;

  const dismissed = localStorage.getItem("pwa-install-dismissed");
  let deferredPrompt = null;

  window.addEventListener("beforeinstallprompt", (event) => {
    event.preventDefault();
    deferredPrompt = event;
    if (!dismissed) banner.hidden = false;
  });

  installBtn?.addEventListener("click", async () => {
    if (!deferredPrompt) return;
    deferredPrompt.prompt();
    await deferredPrompt.userChoice;
    deferredPrompt = null;
    banner.hidden = true;
  });

  dismissBtn?.addEventListener("click", () => {
    banner.hidden = true;
    localStorage.setItem("pwa-install-dismissed", "1");
  });

  window.addEventListener("appinstalled", () => {
    banner.hidden = true;
    deferredPrompt = null;
  });
}

function initFlashBar() {
  const bar = document.querySelector(".flash-bar");
  const closeBtn = bar?.querySelector(".flash-close");
  if (!bar) return;

  closeBtn?.addEventListener("click", () => bar.remove());

  if (window.location.hash === "#contact") {
    document.getElementById("contact-form")?.scrollIntoView({ behavior: "smooth", block: "start" });
  }

  window.setTimeout(() => bar.remove(), 8000);
}
