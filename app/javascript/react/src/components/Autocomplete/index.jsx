

// import React, { useState, useRef, useEffect } from 'react';
// import { ChevronDown, ChevronUp, X } from 'lucide-react';

// const CustomAutocomplete = ({
//   field,
//   form,
//   options,
//   label,
//   width = 300,
//   disabled = false,
//   showClearButton = false, // New prop to control the visibility of the clear button
//   ...props
// }) => {
//   const [isOpen, setIsOpen] = useState(false);
//   const [inputValue, setInputValue] = useState(field.value ? options.find(opt => opt.value === field.value)?.label || '' : '');
//   const [filteredOptions, setFilteredOptions] = useState(options);
//   const inputRef = useRef(null);
//   const listboxRef = useRef(null);
//   const [focusedIndex, setFocusedIndex] = useState(-1);

//   useEffect(() => {
//     const filtered = options.filter(option =>
//       option.label.toLowerCase().includes(inputValue.toLowerCase())
//     );
//     setFilteredOptions(filtered);
//   }, [inputValue, options]);

//   useEffect(() => {
//     const handleClickOutside = (event) => {
//       if (listboxRef.current && !listboxRef.current.contains(event.target) &&
//           !inputRef.current.contains(event.target)) {
//         setIsOpen(false);
//       }
//     };

//     document.addEventListener('mousedown', handleClickOutside);
//     return () => document.removeEventListener('mousedown', handleClickOutside);
//   }, []);

//   const handleInputChange = (e) => {
//     setInputValue(e.target.value);
//     setIsOpen(true);
//     setFocusedIndex(-1);
//     form.setFieldValue(field.name, '');
//   };

//   const handleOptionClick = (option) => {
//     setInputValue(option.label);
//     setIsOpen(false);
//     form.setFieldValue(field.name, option.value);
//   };

//   const handleKeyDown = (e) => {
//     if (e.key === 'ArrowDown') {
//       e.preventDefault();
//       setFocusedIndex(prev =>
//         prev < filteredOptions.length - 1 ? prev + 1 : prev
//       );
//       setIsOpen(true);
//     } else if (e.key === 'ArrowUp') {
//       e.preventDefault();
//       setFocusedIndex(prev => prev > 0 ? prev - 1 : -1);
//     } else if (e.key === 'Enter' && focusedIndex >= 0) {
//       e.preventDefault();
//       handleOptionClick(filteredOptions[focusedIndex]);
//     } else if (e.key === 'Escape') {
//       setIsOpen(false);
//     }
//   };

//   const resetSelection = () => {
//     setInputValue('');
//     form.setFieldValue(field.name, '');
//     setFilteredOptions(options);
//     setIsOpen(true);
//   };

//   return (
//     <div className="custom-autocomplete" style={{ width }}>
//       <div className="input-container">
//         <input
//           {...field}
//           {...props}
//           ref={inputRef}
//           type="text"
//           value={inputValue}
//           onChange={handleInputChange}
//           onFocus={() => setIsOpen(true)}
//           onKeyDown={handleKeyDown}
//           disabled={disabled}
//           className="autocomplete-input"
//           placeholder={props.placeholder || label}
//         />
//         <div className="input-buttons">
//           {showClearButton && inputValue && !disabled && (
//             <button
//               type="button"
//               onClick={(e) => {
//                 e.preventDefault();
//                 resetSelection();
//               }}
//               className="clear-button"
//             >
//               <X size={16} />
//             </button>
//           )}
//           <button
//             type="button"
//             onClick={(e) => {
//               e.preventDefault();
//               if (isOpen) {
//                 setIsOpen(false);
//               } else {
//                 resetSelection();
//               }
//             }}
//             disabled={disabled}
//             className="dropdown-button"
//           >
//             {isOpen ? <ChevronUp size={16} /> : <ChevronDown size={16} />}
//           </button>
//         </div>
//       </div>

//       {isOpen && !disabled && (
//         <ul
//           ref={listboxRef}
//           className="options-list"
//         >
//           {filteredOptions.length === 0 ? (
//             <li className="option-item no-results">No options</li>
//           ) : (
//             filteredOptions.map((option, index) => (
//               <li
//                 key={option.value}
//                 onClick={() => handleOptionClick(option)}
//                 onMouseEnter={() => setFocusedIndex(index)}
//                 className={`option-item ${
//                   focusedIndex === index ? 'focused' : ''
//                 }`}
//               >
//                 {option.label}
//               </li>
//             ))
//           )}
//         </ul>
//       )}
//       <style jsx>{`
//         .custom-autocomplete {
//           position: relative;
//           font-family: Arial, sans-serif;
//         }
//         .input-container {
//           display: flex;
//           align-items: center;
//           border: 1px solid #ccc;
//           border-radius: 4px;
//           overflow: hidden;
//         }
//         .autocomplete-input {
//           flex-grow: 1;
//           border: none;
//           padding: 8px 12px;
//           font-size: 14px;
//           outline: none;
//         }
//         .input-buttons {
//           display: flex;
//           align-items: center;
//         }
//         .clear-button,
//         .dropdown-button {
//           background: none;
//           border: none;
//           cursor: pointer;
//           padding: 4px;
//           color: #777;
//         }
//         .clear-button:hover,
//         .dropdown-button:hover {
//           color: #333;
//         }
//         .options-list {
//           position: absolute;
//           top: 100%;
//           left: 0;
//           right: 0;
//           margin-top: 4px;
//           padding: 0;
//           list-style: none;
//           background-color: white;
//           border: 1px solid #ccc;
//           border-radius: 4px;
//           box-shadow: 0 2px 4px rgba(0,0,0,0.1);
//           max-height: 200px;
//           overflow-y: auto;
//           z-index: 1000;
//         }
//         .option-item {
//           padding: 8px 12px;
//           cursor: pointer;
//         }
//         .option-item:hover,
//         .option-item.focused {
//           background-color: #f0f0f0;
//         }
//         .no-results {
//           color: #777;
//           font-style: italic;
//         }
//       `}</style>
//     </div>
//   );
// };

// export default CustomAutocomplete;


import React, { useState, useRef, useEffect } from 'react';
import { ChevronDown, ChevronUp, X } from 'lucide-react';

const CustomAutocomplete = ({
  field,
  form,
  options,
  label,
  width = 300,
  disabled = false,
  showClearButton = false,
  ...props
}) => {
  const [isOpen, setIsOpen] = useState(false);
  const [inputValue, setInputValue] = useState(field.value ? options.find(opt => opt.value === field.value)?.label || '' : '');
  const [filteredOptions, setFilteredOptions] = useState(options);
  const inputRef = useRef(null);
  const listboxRef = useRef(null);
  const [focusedIndex, setFocusedIndex] = useState(-1);
  const [showAllOptions, setShowAllOptions] = useState(false);

  useEffect(() => {
    if (showAllOptions) {
      setFilteredOptions(options);
    } else {
      const filtered = options.filter(option =>
        option.label.toLowerCase().includes(inputValue.toLowerCase())
      );
      setFilteredOptions(filtered);
    }
  }, [inputValue, options, showAllOptions]);

  useEffect(() => {
    const handleClickOutside = (event) => {
      if (listboxRef.current && !listboxRef.current.contains(event.target) &&
          !inputRef.current.contains(event.target)) {
        setIsOpen(false);
        setShowAllOptions(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleInputChange = (e) => {
    setInputValue(e.target.value);
    setIsOpen(true);
    setFocusedIndex(-1);
    setShowAllOptions(false);
    form.setFieldValue(field.name, '');
  };

  const handleOptionClick = (option) => {
    setInputValue(option.label);
    setIsOpen(false);
    setShowAllOptions(false);
    form.setFieldValue(field.name, option.value);
  };

  const handleKeyDown = (e) => {
    if (e.key === 'ArrowDown') {
      e.preventDefault();
      setFocusedIndex(prev =>
        prev < filteredOptions.length - 1 ? prev + 1 : prev
      );
      setIsOpen(true);
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      setFocusedIndex(prev => prev > 0 ? prev - 1 : -1);
    } else if (e.key === 'Enter' && focusedIndex >= 0) {
      e.preventDefault();
      handleOptionClick(filteredOptions[focusedIndex]);
    } else if (e.key === 'Escape') {
      setIsOpen(false);
      setShowAllOptions(false);
    }
  };

  const toggleDropdown = () => {
    setIsOpen(!isOpen);
    setShowAllOptions(!isOpen);
  };

  return (
    <div className="custom-autocomplete" style={{ width }}>
      <div className="input-container">
        <input
          {...field}
          {...props}
          ref={inputRef}
          type="text"
          value={inputValue}
          onChange={handleInputChange}
          onFocus={() => {
            setIsOpen(true);
            setShowAllOptions(false);
          }}
          onKeyDown={handleKeyDown}
          disabled={disabled}
          className="autocomplete-input"
          placeholder={props.placeholder || label}
        />
        <div className="input-buttons">
          {showClearButton && inputValue && !disabled && (
            <button
              type="button"
              onClick={(e) => {
                e.preventDefault();
                setInputValue('');
                setShowAllOptions(false);
                form.setFieldValue(field.name, '');
              }}
              className="clear-button"
            >
              <X size={16} />
            </button>
          )}
          <button
            type="button"
            onClick={(e) => {
              e.preventDefault();
              toggleDropdown();
            }}
            disabled={disabled}
            className="dropdown-button"
          >
            {isOpen ? <ChevronUp size={16} /> : <ChevronDown size={16} />}
          </button>
        </div>
      </div>

      {isOpen && !disabled && (
        <ul
          ref={listboxRef}
          className="options-list"
        >
          {filteredOptions.length === 0 ? (
            <li className="option-item no-results">No options</li>
          ) : (
            filteredOptions.map((option, index) => (
              <li
                key={option.value}
                onClick={() => handleOptionClick(option)}
                onMouseEnter={() => setFocusedIndex(index)}
                className={`option-item ${
                  focusedIndex === index ? 'focused' : ''
                } ${option.label === inputValue ? 'selected' : ''}`}
              >
                {option.label}
              </li>
            ))
          )}
        </ul>
      )}
      <style jsx>{`
        .custom-autocomplete {
          position: relative;
          font-family: Arial, sans-serif;
        }
        .input-container {
          display: flex;
          align-items: center;
          border: 1px solid #ccc;
          border-radius: 4px;
          overflow: hidden;
        }
        .autocomplete-input {
          flex-grow: 1;
          border: none;
          padding: 8px 12px;
          font-size: 14px;
          outline: none;
        }
        .input-buttons {
          display: flex;
          align-items: center;
        }
        .clear-button,
        .dropdown-button {
          background: none;
          border: none;
          cursor: pointer;
          padding: 4px;
          color: #777;
        }
        .clear-button:hover,
        .dropdown-button:hover {
          color: #333;
        }
        .options-list {
          position: absolute;
          top: 100%;
          left: 0;
          right: 0;
          margin-top: 4px;
          padding: 0;
          list-style: none;
          background-color: white;
          border: 1px solid #ccc;
          border-radius: 4px;
          box-shadow: 0 2px 4px rgba(0,0,0,0.1);
          max-height: 200px;
          overflow-y: auto;
          z-index: 1000;
        }
        .option-item {
          padding: 8px 12px;
          cursor: pointer;
        }
        .option-item:hover,
        .option-item.focused {
          background-color: #f0f0f0;
        }
        .option-item.selected {
          background-color: #e0e0e0;
          font-weight: bold;
        }
        .no-results {
          color: #777;
          font-style: italic;
        }
      `}</style>
    </div>
  );
};

export default CustomAutocomplete;