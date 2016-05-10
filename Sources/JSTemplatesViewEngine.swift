@_exported import Renderable
@_exported import Suv
import Foundation

public struct JSTemplatesViewEngine: Renderable {
    
    public var embedVarName = "__js_templates_view_engine_temlate_data__"
    
    private var templateData: [String: AnyObject]
    
    public init(templateData: [String: AnyObject]){
        self.templateData = templateData
    }
    
    public func render(_ path: String, result: ((Void) throws -> Data) -> Void) {
        FS.readFile(path) {
            if case .Error(let error) = $0 {
                return result {
                    throw error
                }
            }
            
            if case .Success(let buf) = $0 {
                let text = buf.toString()!
                do {
                    let replacing = try "\(dict2JsonString(self.templateData))"
                    result {
                        text.replacingOccurrences(of: "@\(self.embedVarName)", with: replacing).data
                    }
                } catch {
                    result {
                        throw error
                    }
                }
            }
        }
    }
    
}

private func dict2JsonString(_ src: [String: AnyObject]) throws -> String {
    #if os(Linux)
        let jsonData = try NSJSONSerialization.dataWithJSONObject(src as! AnyObject, options: NSJSONWritingOptions(rawValue: 0))
    #else
        let jsonData = try NSJSONSerialization.data(withJSONObject: src as AnyObject, options: NSJSONWritingOptions(rawValue: 0))
    #endif
    
    let jsonStr = String(NSString(data: jsonData, encoding: NSUTF8StringEncoding)!)
    
    return jsonStr
}