module UserRolesEnum
  extend ActiveSupport::Concern

  included do
    enum role: {
      CERTIFIED_NURSING_ASSISTANT: "Certified Nursing Assistant",
      DENTAL_HYGIENIST: "Dental Hygienist",
      DENTIST: "Dentist",
      LICENSED_PRACTICAL_NURSE: "Licensed Practical Nurse",
      MEDICAL_ASSISTANT: "Medical Assistant",
      NURSE_ANESTHETIST: "Nurse Anesthetist",
      NURSE_MIDWIFE: "Nurse Midwife",
      NURSE_PRACTITIONER: "Nurse Practitioner",
      OCCUPATIONAL_THERAPIST: "Occupational Therapist",
      OPTHALMOLOGIST: "Opthalmologist",
      OPTOMETRIST: "Optometrist",
      OTHER: "Other",
      PHARMACIST: "Pharmacist",
      PHYSICAL_THERAPIST: "Physical Therapist",
      PHYSICIAN: "Physician",
      PHYSICIAN_ASSISTANT: "Physician Assistant",
      PSYCHOLOGIST: "Psychologist",
      RADIOLOGIC_TECHNOLOGIST: "Radiologic Technologist",
      REGISTERED_NURSE: "Registered Nurse",
      RESPIRATION_THERAPIST: "Respiration Therapist",
      SOCIAL_WORKER: "Social Worker",
      SPEECH_LANGUAGE_PATHOLOGIST: "Speech Language Pathologist",
      STUDENT: "Student"
    }
    
    validates :user_type, inclusion: { in: User.roles.keys }
  end
end