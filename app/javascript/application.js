// Arqvexa — navigation, scroll effects, PWA
document.addEventListener("DOMContentLoaded", () => {
  initNavigation();
  initScrollReveal();
  initScrollSpy();
  initBackToTop();
  initServiceWorker();
  initInstallPrompt();
  initFlashBar();
  initContactHashScroll();
  initContactForm();
  initPortfolioFilter();
  initTools();
  initPortfolioGallery();
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

  window.setTimeout(() => bar.remove(), 8000);
}

function initContactHashScroll() {
  if (window.location.hash !== "#contact") return;

  const target = document.getElementById("contact-form") || document.getElementById("contact");
  if (!target) return;

  requestAnimationFrame(() => {
    target.scrollIntoView({ behavior: "smooth", block: "start" });
  });
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
          "Could not send your message right now. Please use the contact form below or WhatsApp us.",
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

function initTools() {
  initKitchenCalculator();
  initBhkCalculator();
  initWebsiteCalculator();
  initProjectRecommender();
}

function formatLakhs(amount) {
  if (amount >= 100000) {
    const lowL = (amount / 100000).toFixed(1).replace(/\.0$/, "");
    return `₹${lowL} lakh`;
  }
  return `₹${Math.round(amount / 1000)}K`;
}

function formatRange(low, high) {
  return `${formatLakhs(low)} – ${formatLakhs(high)}`;
}

function showToolResult(panel, value, note) {
  const result = panel.querySelector(".tool-result");
  const valueEl = panel.querySelector("[data-result-value]");
  const noteEl = panel.querySelector("[data-result-note]");
  if (!result || !valueEl) return;

  valueEl.textContent = value;
  if (noteEl) noteEl.textContent = note || "";
  result.hidden = false;
  result.scrollIntoView({ behavior: "smooth", block: "nearest" });
}

function initKitchenCalculator() {
  const panel = document.querySelector('[data-tool="kitchen-calculator"]');
  const form = panel?.querySelector("form");
  if (!form) return;

  const rates = { laminate: 3400, acrylic: 4800, pu: 6500 };
  const layoutMult = { l: 1, u: 1.18, parallel: 1.1, island: 1.38 };
  const cityMult = { delhi: 1, gurgaon: 1.05, noida: 1.03 };

  form.addEventListener("submit", (event) => {
    event.preventDefault();
    const size = Number(form.querySelector('[name="size"]')?.value || 135);
    const layout = form.querySelector('[name="layout"]')?.value || "l";
    const finish = form.querySelector('[name="finish"]')?.value || "laminate";
    const city = form.querySelector('[name="city"]')?.value || "gurgaon";

    const base = size * rates[finish] * layoutMult[layout] * cityMult[city];
    const low = Math.round(base * 0.88 / 10000) * 10000;
    const high = Math.round(base * 1.22 / 10000) * 10000;

    const cityLabel = { delhi: "Delhi", gurgaon: "Gurgaon", noida: "Noida" }[city];
    showToolResult(
      panel,
      formatRange(low, high),
      `Typical modular kitchen in ${cityLabel} at this size and finish — excludes appliances unless specified.`
    );
  });
}

function initBhkCalculator() {
  const panel = document.querySelector('[data-tool="bhk-calculator"]');
  const form = panel?.querySelector("form");
  if (!form) return;

  const ranges = {
    2: { essential: [450000, 850000], standard: [900000, 1600000], premium: [1700000, 2800000] },
    3: { essential: [650000, 1100000], standard: [1300000, 2400000], premium: [2400000, 4200000] },
    4: { essential: [950000, 1600000], standard: [1900000, 3400000], premium: [3600000, 5800000] }
  };
  const cityMult = { delhi: 1, gurgaon: 1.06, noida: 1.04 };

  form.addEventListener("submit", (event) => {
    event.preventDefault();
    const bhk = form.querySelector('[name="bhk"]')?.value || "3";
    const scope = form.querySelector('[name="scope"]')?.value || "standard";
    const city = form.querySelector('[name="city"]')?.value || "gurgaon";

    const [baseLow, baseHigh] = ranges[bhk][scope];
    const mult = cityMult[city];
    const low = Math.round((baseLow * mult) / 10000) * 10000;
    const high = Math.round((baseHigh * mult) / 10000) * 10000;

    const bhkLabel = { 2: "2BHK", 3: "3BHK", 4: "4BHK / large home" }[bhk];
    showToolResult(
      panel,
      formatRange(low, high),
      `Indicative ${bhkLabel} interior budget — civil work and appliances quoted separately.`
    );
  });
}

function initWebsiteCalculator() {
  const panel = document.querySelector('[data-tool="website-calculator"]');
  const form = panel?.querySelector("form");
  if (!form) return;

  const baseRanges = {
    landing: { small: [18000, 45000], medium: [35000, 75000], large: [65000, 120000] },
    business: { small: [45000, 95000], medium: [85000, 180000], large: [160000, 320000] },
    ecommerce: { small: [120000, 250000], medium: [220000, 450000], large: [400000, 850000] }
  };
  const featureAdd = { blog: 15000, booking: 25000, payments: 45000, crm: 90000 };

  form.addEventListener("submit", (event) => {
    event.preventDefault();
    const type = form.querySelector('[name="type"]')?.value || "business";
    const pages = form.querySelector('[name="pages"]')?.value || "medium";
    const features = [...form.querySelectorAll('[name="feature"]:checked')].map((el) => el.value);

    const [baseLow, baseHigh] = baseRanges[type][pages];
    const extra = features.reduce((sum, f) => sum + (featureAdd[f] || 0), 0);
    const low = baseLow + extra;
    const high = baseHigh + Math.round(extra * 1.15);

    const typeLabel = {
      landing: "landing page",
      business: "business website",
      ecommerce: "e-commerce store"
    }[type];

    showToolResult(
      panel,
      formatRange(low, high),
      `Indicative ${typeLabel} budget in India — content writing, hosting and ongoing maintenance are separate.`
    );
  });
}

function initProjectRecommender() {
  const panel = document.querySelector('[data-tool="project-recommender"]');
  const form = panel?.querySelector("form");
  if (!form) return;

  const recommendations = {
    website: {
      title: "Business website or landing page",
      note: "Best when you mainly need online presence, service information and a way for customers to contact you.",
      path: "/it-development/web-development"
    },
    ecommerce: {
      title: "E-commerce store",
      note: "Best when selling products online with cart, payments and order management is the core goal.",
      path: "/it-development/ecommerce-development"
    },
    crm: {
      title: "CRM or custom business software",
      note: "Best when your team needs to track leads, clients, workflows or internal operations in one place.",
      path: "/it-development/crm-development"
    },
    mobile: {
      title: "Mobile app",
      note: "Best when users need a dedicated app experience — bookings, accounts, notifications or on-the-go access.",
      path: "/it-development/mobile-app-development"
    },
    ai: {
      title: "AI chatbot or automation",
      note: "Best for FAQ handling, lead qualification or repetitive support tasks that can be automated.",
      path: "/it-development/ai-development"
    }
  };

  form.addEventListener("submit", (event) => {
    event.preventDefault();
    const goal = form.querySelector('[name="goal"]')?.value;
    const users = form.querySelector('[name="users"]')?.value;
    const complexity = form.querySelector('[name="complexity"]')?.value;
    const budget = form.querySelector('[name="budget"]')?.value;

    let key = "website";
    if (goal === "sell") key = "ecommerce";
    else if (goal === "operations" || (users === "team" && complexity !== "simple")) key = "crm";
    else if (goal === "mobile") key = "mobile";
    else if (goal === "support") key = "ai";
    else if (complexity === "complex" && users !== "public") key = "crm";
    else if (budget === "enterprise" && complexity === "complex") key = "crm";

    const rec = recommendations[key];
    const linkEl = panel.querySelector("[data-result-link]");
    showToolResult(panel, rec.title, rec.note);
    if (linkEl) {
      linkEl.innerHTML = `<a href="${rec.path}" class="text-link">Learn about ${rec.title.toLowerCase()} →</a>`;
    }
  });
}

function initPortfolioGallery() {
  document.querySelectorAll("[data-portfolio-gallery]").forEach((gallery) => {
    const slides = [...gallery.querySelectorAll(".portfolio-gallery-slide")];
    const dots = [...gallery.querySelectorAll("[data-gallery-dot]")];
    const thumbs = [...gallery.querySelectorAll("[data-gallery-thumb]")];
    const prevBtn = gallery.querySelector("[data-gallery-prev]");
    const nextBtn = gallery.querySelector("[data-gallery-next]");
    const counter = gallery.querySelector("[data-gallery-counter]");
    const progressBar = gallery.querySelector("[data-gallery-progress]");
    const backdrop = gallery.querySelector("[data-gallery-backdrop]");
    const track = gallery.querySelector("[data-gallery-track]");
    if (!slides.length) return;

    let current = 0;
    let timer = null;
    const prefersReduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    const autoplayMs = prefersReduced ? 0 : 5500;

    const slideImage = (index) => slides[index]?.querySelector(".portfolio-gallery-image");

    const fitTrack = (index) => {
      if (!track) return;
      const img = slideImage(index);
      if (!img?.naturalWidth) return;

      const ratio = img.naturalWidth / img.naturalHeight;
      track.classList.remove("is-portrait", "is-square");

      if (ratio < 0.92) {
        track.classList.add("is-portrait");
      } else if (ratio < 1.08) {
        track.classList.add("is-square");
      }
    };

    const updateBackdrop = (index) => {
      if (!backdrop) return;
      const img = slideImage(index);
      const src = img?.currentSrc || img?.src;
      if (src) backdrop.style.backgroundImage = `url("${src}")`;
    };

    const bindImageFit = (slide, index) => {
      const img = slideImage(index);
      if (!img) return;
      const onReady = () => {
        if (index === current) {
          fitTrack(index);
          updateBackdrop(index);
        }
      };
      if (img.complete) onReady();
      else img.addEventListener("load", onReady, { once: true });
    };

    slides.forEach((slide, index) => bindImageFit(slide, index));

    const setSlide = (index) => {
      current = (index + slides.length) % slides.length;
      slides.forEach((slide, i) => slide.classList.toggle("is-active", i === current));
      dots.forEach((dot, i) => {
        dot.classList.toggle("is-active", i === current);
        dot.setAttribute("aria-selected", i === current ? "true" : "false");
      });
      thumbs.forEach((thumb, i) => {
        thumb.classList.toggle("is-active", i === current);
        if (i === current) {
          thumb.scrollIntoView({ behavior: prefersReduced ? "auto" : "smooth", block: "nearest", inline: "center" });
        }
      });
      if (counter) counter.textContent = `${current + 1} / ${slides.length}`;
      if (progressBar) {
        progressBar.style.width = `${((current + 1) / slides.length) * 100}%`;
      }
      fitTrack(current);
      updateBackdrop(current);
    };

    const next = () => setSlide(current + 1);
    const prev = () => setSlide(current - 1);

    const restartAutoplay = () => {
      if (!autoplayMs || slides.length < 2) return;
      clearInterval(timer);
      timer = window.setInterval(next, autoplayMs);
    };

    nextBtn?.addEventListener("click", () => {
      next();
      restartAutoplay();
    });
    prevBtn?.addEventListener("click", () => {
      prev();
      restartAutoplay();
    });
    dots.forEach((dot) => {
      dot.addEventListener("click", () => {
        setSlide(Number(dot.dataset.galleryDot));
        restartAutoplay();
      });
    });
    thumbs.forEach((thumb) => {
      thumb.addEventListener("click", () => {
        setSlide(Number(thumb.dataset.galleryThumb));
        restartAutoplay();
      });
    });

    gallery.addEventListener("mouseenter", () => clearInterval(timer));
    gallery.addEventListener("mouseleave", restartAutoplay);

    let touchStartX = 0;
    gallery.addEventListener(
      "touchstart",
      (event) => {
        touchStartX = event.changedTouches[0]?.screenX || 0;
      },
      { passive: true }
    );
    gallery.addEventListener(
      "touchend",
      (event) => {
        const touchEndX = event.changedTouches[0]?.screenX || 0;
        const diff = touchEndX - touchStartX;
        if (Math.abs(diff) < 45) return;
        if (diff < 0) next();
        else prev();
        restartAutoplay();
      },
      { passive: true }
    );

    gallery.addEventListener("keydown", (event) => {
      if (event.key === "ArrowRight") {
        next();
        restartAutoplay();
      }
      if (event.key === "ArrowLeft") {
        prev();
        restartAutoplay();
      }
    });

    setSlide(0);
    restartAutoplay();
  });
}

function initPortfolioFilter() {
  document.querySelectorAll("[data-portfolio-filter]").forEach((section) => {
    const filters = section.querySelectorAll(".portfolio-filter[data-filter]");
    const cards = section.querySelectorAll(".portfolio-card[data-category]");
    if (!filters.length || !cards.length) return;

    filters.forEach((btn) => {
      btn.addEventListener("click", (event) => {
        if (btn.tagName === "A") return;

        event.preventDefault();
        const filter = btn.dataset.filter;

        filters.forEach((el) => {
          const active = el === btn;
          el.classList.toggle("is-active", active);
          el.setAttribute("aria-selected", active ? "true" : "false");
        });

        cards.forEach((card) => {
          const show = filter === "all" || card.dataset.category === filter;
          card.hidden = !show;
          card.style.display = show ? "" : "none";
        });
      });
    });
  });
}
