// Arqvexa — navigation, scroll effects, PWA
document.addEventListener("DOMContentLoaded", () => {
  initNavigation();
  initScrollReveal();
  initScrollSpy();
  initBackToTop();
  initServiceWorker();
  initInstallPrompt();
  initFlashBar();
  initContactForm();
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

function initContactForm() {
  document.querySelectorAll("form.contact-form[data-web3forms-key]").forEach((form) => {
    const accessKey = form.dataset.web3formsKey;
    if (!accessKey) return;

    form.addEventListener("submit", async (event) => {
      event.preventDefault();

      const submitBtn = form.querySelector('[type="submit"]');
      const statusEl = form.querySelector(".form-status");
      const website = form.querySelector('[name="contact_message[website]"]');

      if (website?.value) {
        showFormStatus(statusEl, "Thank you! We will get back to you within 24 hours.", "success");
        form.reset();
        return;
      }

      const field = (name) => form.querySelector(`[name="contact_message[${name}]"]`)?.value?.trim() || "";
      const name = field("name");
      const email = field("email");
      const phone = field("phone");
      const service = field("service");
      const message = field("message");

      if (!name || !email || !message) {
        showFormStatus(statusEl, "Please fill in all required fields.", "error");
        return;
      }

      const defaultLabel = submitBtn?.value || "Send Message";
      if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.value = "Sending...";
      }
      showFormStatus(statusEl, "Sending your message...", "info");

      try {
        const response = await fetch("https://api.web3forms.com/submit", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Accept: "application/json"
          },
          body: JSON.stringify({
            access_key: accessKey,
            subject: `New enquiry — ${service || "Arqvexa"} — ${name}`,
            name,
            email,
            phone,
            service,
            message,
            from_name: "Arqvexa Website",
            replyto: email,
            botcheck: ""
          })
        });

        const data = await response.json();
        const ok = data.success === true;
        const msg =
          data.message ||
          data.body?.message ||
          (ok ? "Message sent successfully! We will reply within 24 hours." : "Could not send your message.");

        if (ok) {
          showFormStatus(statusEl, msg, "success");
          form.reset();
        } else {
          showFormStatus(statusEl, msg, "error");
        }
      } catch {
        showFormStatus(
          statusEl,
          "Could not send your message right now. Please WhatsApp us or email mohdasif.dev01@gmail.com directly.",
          "error"
        );
      } finally {
        if (submitBtn) {
          submitBtn.disabled = false;
          submitBtn.value = defaultLabel;
        }
      }
    });
  });
}

function showFormStatus(el, message, type) {
  if (!el) return;
  el.hidden = false;
  el.textContent = message;
  el.className = `form-status form-status--${type}`;
  if (type === "success") {
    el.scrollIntoView({ behavior: "smooth", block: "nearest" });
  }
}
