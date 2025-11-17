//
//  DocumentScannerView.swift
//  Transactions
//
//  Created by Daniyar Yegeubay on 17/11/25.
//

import SwiftUI
import VisionKit
import Vision

struct DocumentScannerView: UIViewControllerRepresentable {
    @Binding var scannedText: String
       @Environment(\.dismiss) private var dismiss
       
       func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
           let scanner = VNDocumentCameraViewController()
           scanner.delegate = context.coordinator
           return scanner
       }
       
       func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
       
       func makeCoordinator() -> Coordinator {
           Coordinator(self)
       }
       
       class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
           let parent: DocumentScannerView
           
           init(_ parent: DocumentScannerView) {
               self.parent = parent
           }
           
           func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
               // Process scanned images
               for pageIndex in 0..<scan.pageCount {
                   let image = scan.imageOfPage(at: pageIndex)
                   recognizeText(from: image)
               }
               parent.dismiss()
           }
           
           func recognizeText(from image: UIImage) {
               guard let cgImage = image.cgImage else { return }
               
               let request = VNRecognizeTextRequest { request, error in
                   guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                   
                   let recognizedText = observations.compactMap { observation in
                       observation.topCandidates(1).first?.string
                   }.joined(separator: "\n")
                   
                   DispatchQueue.main.async {
                       self.parent.scannedText = recognizedText
                   }
               }
               
               request.recognitionLevel = .accurate
               
               let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
               try? handler.perform([request])
           }
           
           func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
               parent.dismiss()
           }
       }
}

//#Preview {
//    DocumentScannerView()
//}
