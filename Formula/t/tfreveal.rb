class Tfreveal < Formula
  desc "CLI to show Terraform plan with all the secret (sensitive) values revealed"
  homepage "https://github.com/breml/tfreveal"
  url "https://github.com/breml/tfreveal/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "392ea05d250c6a19254e10643ba45a5bff16c566b81cba8a0e5527aff3317ced"
  license "MIT"
  head "https://github.com/breml/tfreveal.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    resource "tfplan.json" do
      url "https://raw.githubusercontent.com/breml/tfreveal/refs/heads/master/testdata/sensitive/plan.json"
      sha256 "56e1460d2eab4978ff3348a22718fc89c4eebc2e4af41d29efcb1cd10589dc5f"
    end

    assert_match version.to_s, shell_output("#{bin}/tfreveal -v")

    testpath.install resource("tfplan.json")
    output = shell_output("#{bin}/tfreveal --no-color #{testpath}/plan.json")
    assert_match "null_resource.sensitive must be replaced", output
  end
end
