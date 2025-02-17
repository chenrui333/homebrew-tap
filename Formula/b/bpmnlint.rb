class Bpmnlint < Formula
  desc "Validate BPMN diagrams based on configurable lint rules"
  homepage "https://github.com/bpmn-io/bpmnlint"
  url "https://registry.npmjs.org/bpmnlint/-/bpmnlint-11.1.0.tgz"
  sha256 "5364956ff2a2f7d90e1fc10cf22bca6526f8766bed95608fcaa4c83c29df869c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e6f7370ead5e14a25558fcc7cd975544fb43d2b84478b22d1f5a117b7863505"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "374169ff1f9b0e61789c462627eb092215599dbca0743256385ef8b756aad855"
    sha256 cellar: :any_skip_relocation, ventura:       "9139def10201cc02d0d2e70eb46c96b3c956f6435fcb9e83d157d8728c2483cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a626ee9ac540de65eaa22195dfb0c7038b2f210520e737db0dd241c8ba3a3515"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/bpmnlint"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bpmnlint --version")

    system bin/"bpmnlint", "--init"
    assert_match "\"extends\": \"bpmnlint:recommended\"", (testpath/".bpmnlintrc").read

    (testpath/"diagram.bpmn").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <bpmn:definitions xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" id="Definitions_1">
        <bpmn:process id="Process_1" isExecutable="false">
          <bpmn:startEvent id="StartEvent_1"/>
        </bpmn:process>
      </bpmn:definitions>
    XML

    output = shell_output("#{bin}/bpmnlint diagram.bpmn 2>&1", 1)
    assert_match "Process_1     error  Process is missing end event   end-event-required", output
  end
end
