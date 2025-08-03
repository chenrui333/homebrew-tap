class VetRun < Formula
  desc "Safer way to run remote scripts"
  homepage "https://getvet.sh/"
  url "https://github.com/vet-run/vet/releases/download/v1.0.2/vet"
  sha256 "1b85c98f4f29be13b908ec225f53a70f90c0da5025759810a55961f7c6274878"
  license "MIT"

  depends_on "curl"

  def install
    bin.install "vet"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet --help 2>&1", 1)

    output = shell_output("#{bin}/vet --force https://my-trusted-internal-script.sh 2>&1", 1)
    assert_match "Could not resolve host: my-trusted-internal-script.sh", output
  end
end
