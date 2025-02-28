class Bpmnlint < Formula
  desc "Validate BPMN diagrams based on configurable lint rules"
  homepage "https://github.com/bpmn-io/bpmnlint"
  url "https://registry.npmjs.org/bpmnlint/-/bpmnlint-11.4.2.tgz"
  sha256 "13029d4c6e3f9480dff23eaa389cd0648ba8aaefb9b3c4c5e809fff6999c6ba2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0a20a1f469ac26d9cf9f345665f6f966708137f4c6fe039b589cc410a832bba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ebd2c8337d97aa37402c1a3d68746b77501bb1129d18f6c42854d0a631395c5"
    sha256 cellar: :any_skip_relocation, ventura:       "41b2d8028f19a388fc4eaf4bf1120d63eec23077cb0870627e293146b4179864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "473369991b50003222288374a114e35f1913ab5d0627270477dd9b60145b0a32"
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
