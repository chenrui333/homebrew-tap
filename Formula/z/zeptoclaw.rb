class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "eec202a03a1a7d2910e6df5bc33da60c3627cd3668d7f153b0dbcec4aa209698"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3422db8e08e7b2817d85bc39b9be36726c9feaef1e9d54b1c6a97a4465c1d3ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "155f15589af8b573ec8765296fdfcf9401001f4d0078a109c49a3890c83a5cce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f66817c4c006f80dcfab10272f199a4d7853ea134ec8eaab9f27eca8a62918bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f88fd0b91a2a15ab56767e6c31efa72300906ed19bc50d67be71eae78db7dd03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de617091eb8422e49436261c0ead6f1f989cc7f6a2bc312cf1f1e0267bbf82e2"
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
