class Livediff < Formula
  desc "Watch file differences in the terminal"
  homepage "https://github.com/SoCkEt7/Livediff"
  url "https://github.com/SoCkEt7/Livediff/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "41b3d22f646cd16beadd4ff72868f76badf561f93c9996329c30ef6a40d576d7"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/SoCkEt7/Livediff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d784f65dc2edac108f4994b4b04285e8020c787deb5186703b6590ed03b383a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d56ba68f87c7974743dab6532f9bc8eba3ae0522f4d532cb3f9905f841b578a7"
    sha256 cellar: :any,                 arm64_linux:   "abce4209099f2d4cad6636bfb3f942525de580b75c59a0a2dba290c10d37fe15"
    sha256 cellar: :any,                 x86_64_linux:  "50ec9aac193d1c46f24d180ab7d380bd86a7ec96ee248f25cdf56721f2a3990b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/livediff --version")
    output = shell_output("#{bin}/livediff --invalid-option 2>&1", 2)
    assert_match "unexpected argument '--invalid-option'", output
  end
end
