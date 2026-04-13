class Kdash < Formula
  desc "Simple and fast dashboard for Kubernetes"
  homepage "https://kdash.cli.rs/"
  url "https://github.com/kdash-rs/kdash/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "b53a2997af2bfcb4170639dd671aa5b816321002cff6da1b41bb209ed27fe3ff"
  license "MIT"
  head "https://github.com/kdash-rs/kdash.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97fed814d759ea4b2411b8ec752e0145bf081befbe47e0dd588236d6b01510e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43a8a1d30b7165f911c99e08ea5507f2d1627474237f81a8c737911f011a7e58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "850acfeb8746910cac7c8b1313ac981691b6ab4f4223bbab146dcb8c8965d5dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c233584395f8f07316fa57c24b670bf0c0008e2ce08ac946f49eee8c7a7ebd0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4c3ddeaef8e73bf96d5db16e19298b1bf42b04fff6b54f9c9e29e9b86b730eb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kdash --version")

    # failed with Linux CI, `No such device or address (os error 6)` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"kdash", [:out, :err] => output_log.to_s
      sleep 1
      output = output_log.read.gsub(%r{\e\[[\d;?]*[ -/]*[@-~]}, "")
      assert_match(/Failed to load .* config/i, output)
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
