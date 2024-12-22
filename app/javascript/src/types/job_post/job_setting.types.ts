import { useState, useEffect } from "react";
import { useJobSettings } from "@hooks";

const [settings, setSettings] = useState<
  {
    id: number;
    setting_name: string;
  }[]
>([]);

const { settings: allSettings } = useJobSettings();

useEffect(() => {
  if (allSettings) {
    setSettings(allSettings);
  }
}, [allSettings]);

export type JobSettings = (typeof settings)[number];

export interface JobSetting {
  id: JobSettings["id"];
  setting_name: JobSettings["setting_name"];
}
