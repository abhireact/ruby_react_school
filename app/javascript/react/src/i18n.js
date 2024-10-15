import i18n from "i18next";
import { initReactI18next } from "react-i18next";
import commonArabic from "../../language.json";

i18n.use(initReactI18next).init({
  lng: "hindi",
  resources: {
    en: {
      common: {
        Hi: "Hello World",
        HOME: "Welcome Home",
      },
    },
    hindi: {
      common: {
        Hi: "हैलो वर्ल्ड",
        HOME: "सुस्वागतम्",
      },
    },
    arabic: {
      common: commonArabic,
    },
  },
  fallbackLng: "hindi",
  interpolation: {
    escapeValue: false,
  },
});

export default i18n;
