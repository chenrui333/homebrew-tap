class Envdiff < Formula
  desc "Tool to snapshot and diff environments"
  homepage "https://github.com/GBerghoff/envdiff"
  url "https://github.com/GBerghoff/envdiff/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "604cef7dbfa1d9639751b102c6b44a505dc8a1602de22bd18566fcbcb7a0eb20"
  license "MIT"
  head "https://github.com/GBerghoff/envdiff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93c5319dda3dbe3c6b95f3c30874657852ad95d395935834e33182dc0409217f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93c5319dda3dbe3c6b95f3c30874657852ad95d395935834e33182dc0409217f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93c5319dda3dbe3c6b95f3c30874657852ad95d395935834e33182dc0409217f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4798ad52db555e80ec698065eeb800f2f55cf9c447bdf39cf16b96057378c64f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eab84266bab4a6e2dea1bd0d68f1bfeb160fb3923639a583d8e09fb4da71379b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/envdiff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envdiff --version")

    system bin/"envdiff", "init"
    assert_path_exists testpath/"envdiff.yaml"

    system bin/"envdiff", "snapshot", "-o", "snapshot.json"
    assert_path_exists testpath/"snapshot.json"

    output = shell_output("#{bin}/envdiff render snapshot.json")
    assert_match "SYSTEM", output
    assert_match "RUNTIME", output
  end
end
