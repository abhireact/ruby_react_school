import i18n from "i18next";
import { initReactI18next } from "react-i18next";

i18n.use(initReactI18next).init({
  resources: {
    en: {
      translation: {
        welcome: "Welcome to the application",
        "Basic Info": "Basic Info",
      },
    },
    hi: {
      translation: {
        welcome: "Bienvenue dans l'application",
        "Basic Info": "बुनियादी जानकारी",
      },
    },
  },
  lng: "hi", // Default language
  fallbackLng: "en",
  interpolation: {
    escapeValue: false,
  },
});

export default i18n;
