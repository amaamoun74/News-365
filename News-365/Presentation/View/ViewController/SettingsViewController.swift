//
//  SettingsViewController.swift
//  News-365
//
//  Created by ahmed on 26/08/2023.
//

import UIKit
import ADCountryPicker

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var btnNewsCountry: UIButton!
    @IBOutlet weak var switchBtnDarkMode: UISwitch!
    @IBOutlet weak var segmentLanguage: UISegmentedControl!
    @IBOutlet weak var lblDarkMode: UILabel!
    @IBOutlet weak var lblNewsCountry: UILabel!
    @IBOutlet weak var lblAppLanguage: UILabel!
    private let picker = ADCountryPicker(style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        setSegmentLanguage()
        configurViewLanguage()
        configureCountryPicker()
    }
    override func viewWillAppear(_ animated: Bool) {
        btnNewsCountry.setTitle(UserDefaults.standard.value(forKey: Constants.shared.COUNTRYCODE ) as? String ?? "EG", for: .normal)
        switchBtnDarkMode.isOn = traitCollection.userInterfaceStyle == .dark
    }
    @IBAction func selectLanguage(_ sender: Any) {
        showAlert()
    }
    
    @IBAction func setDarkMode(_ sender: UISwitch) {
           
        let theme: AppTheme = sender.isOn ? .dark : .light
           let appDelegate = UIApplication.shared.delegate as? AppDelegate
           appDelegate?.updateAppTheme(theme: theme)
    }
    @IBAction func setNewsCountry(_ sender: Any) {
        navigationController?.pushViewController(picker, animated: true)
    }
}

extension SettingsViewController {
    func showAlert(){
        let title = NSLocalizedString("alert_title", comment: "")
        let msg = NSLocalizedString("alert_message", comment: "")
        let firtsActionTitle = NSLocalizedString("ok", comment: "")
        let secondActionTitle = NSLocalizedString("cancle", comment: "")
        
        let alert : UIAlertController = UIAlertController(title:title , message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: secondActionTitle, style: .cancel , handler: { action in
            self.setSegmentLanguage()
        }))
        
        alert.addAction(UIAlertAction(title: firtsActionTitle, style: .default , handler: { action in
            self.changeLanguage()
        }))
        
        self.present(alert, animated: true , completion: nil )
    }
    
    private func changeLanguage(){
        let currentLanguage = Locale.current.language.languageCode?.identifier
        let newLanguage = segmentLanguage.titleForSegment(at: segmentLanguage.selectedSegmentIndex)
        print("language: \(String(describing: newLanguage?.lowercased()))" )
        print("oldlanguage: \(String(describing: currentLanguage))" )
        if currentLanguage != newLanguage {
            UserDefaults.standard.set([newLanguage!.lowercased()], forKey: Constants.shared.APPLE_LANGUAGES)
            exit(0)
        }
    }
    private func setSegmentLanguage(){
        if let currentLanguage = Locale.current.language.languageCode?.identifier
        {
            let index = currentLanguage == "en" ? 0 : 1
            segmentLanguage.selectedSegmentIndex = index
        }
    }
    private func configurViewLanguage(){
        lblDarkMode.text = NSLocalizedString("dark_mode", comment: "")
        lblNewsCountry.text = NSLocalizedString("news_countery", comment: "")
        lblAppLanguage.text = NSLocalizedString("app_language", comment: "")
    }
}

extension SettingsViewController: ADCountryPickerDelegate{

    private func configureCountryPicker(){
        picker.delegate = self
        picker.showCallingCodes = false
        picker.showFlags = true
        picker.pickerTitle = NSLocalizedString("select_Country", comment: "")
        picker.defaultCountryCode = "EG"
        picker.forceDefaultCountryCode = false
        picker.alphabetScrollBarTintColor = UIColor(named: "thirdRed")!
        picker.alphabetScrollBarBackgroundColor = UIColor.clear
        picker.closeButtonTintColor = .systemBackground
        picker.font = UIFont(name: "Helvetica Neue" , size: 16 )
        picker.flagHeight = 40
        picker.hidesNavigationBarWhenPresentingSearch = true
        picker.searchBarBackgroundColor = .systemBackground
    }
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String) {
        UserDefaults.standard.set(code, forKey: Constants.shared.COUNTRYCODE)
        btnNewsCountry.setTitle(code, for: .normal)
            print(code)
        picker.navigationController?.popViewController(animated: true)

    }

    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
            print(dialCode)
    }
    
}
