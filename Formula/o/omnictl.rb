class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.13.3.tar.gz"
  sha256 "ed1b2792e5fea26795e319293951b9194023bedd873041831825d9a8adc58d48"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecdc46cdaf6b5650f4819e5beb7a1c7ae32318cd31c43dbb54106c11ad5367d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15b445784a3d291497bd53ba4f8919ddd3f6f3bb6cb42cc4f9a3b80892843a4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc7c83c8c0f90a252c3e45bfcdbb2abb0b4fc57374d32b7aff9d7fc609165826"
    sha256 cellar: :any,                 x86_64_linux:  "ce4aca6f3afd56c5c081bd70c4c09ff2881fbc090824367cfed153f2f3571679"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omnictl --version")

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    system bin/"omnictl", "config", "add", "staging", "--url", "https://omni.example.com"
    system bin/"omnictl", "config", "context", "staging"
    assert_match "Current context: staging", shell_output("#{bin}/omnictl config info")
    assert_match %r{\*\s+staging\s+https://omni\.example\.com}, shell_output("#{bin}/omnictl config contexts")
  end
end
