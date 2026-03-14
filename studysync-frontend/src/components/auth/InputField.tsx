import React, { useState } from 'react';
import './InputField.scss';

interface InputFieldProps {
  label: string;
  type?: string;
  placeholder?: string;
  value?: string;
  onChange?: (e: React.ChangeEvent<HTMLInputElement>) => void;
  showToggle?: boolean;
}

const InputField: React.FC<InputFieldProps> = ({
  label,
  type = 'text',
  placeholder,
  value,
  onChange,
  showToggle = false,
}) => {
  const [visible, setVisible] = useState(false);
  const inputType = showToggle ? (visible ? 'text' : 'password') : type;

  return (
    <div className="input-field">
      <label className="input-field__label">
        <p className="input-field__label-text">{label}</p>
        <div className="input-field__wrapper">
          <input
            className={`input-field__input ${showToggle ? 'input-field__input--with-toggle' : ''}`}
            type={inputType}
            placeholder={placeholder}
            value={value}
            onChange={onChange}
          />
          {showToggle && (
            <div className="input-field__toggle" onClick={() => setVisible(!visible)}>
              <span className="material-symbols-outlined">
                {visible ? 'visibility_off' : 'visibility'}
              </span>
            </div>
          )}
        </div>
      </label>
    </div>
  );
};

export default InputField;