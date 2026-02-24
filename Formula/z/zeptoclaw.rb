class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "9df5ce34bee506b2968af7b8d257a4574d72dc8f8978c72756f7e61954fc120a"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f1bdcb5ac06375eca97835fa2b2ead2dfe1fc057a7d1d62730788a62b1113f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa6cd75b4e207c2d2f1358c857e2814ccee36df58c53bf5b1fdebe48df18f5f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9f062c3a2818f6835343d04817ae71f8ba25f9f60c8fc803e275fb85e3dc282"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a613018369bcbe297e2b2f8de9c4ae7922f19c72cd4bdc4e8570027b1e740950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0081c65a3cfbbaa1f2f31fa1ad95c6031ce5d0e576fd6ed90f9e1399e244128f"
  end

  depends_on "rust" => :build

  def install
    # upstream bug report on the build target issue, https://github.com/qhkm/zeptoclaw/issues/119
    system "cargo", "install", "--bin", "zeptoclaw", *std_cargo_args
  end

  service do
    run [opt_bin/"zeptoclaw", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeptoclaw --version")
    assert_match "No config file found", shell_output("#{bin}/zeptoclaw config check")
  end
end
