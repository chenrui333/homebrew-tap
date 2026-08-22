class FxAgent < Formula
  desc "Tiny, open, embeddable, native coding agent"
  homepage "https://fx.sh"
  url "https://github.com/vercel-labs/fx/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "82d1aefaf2eac25631307227ccd36405cc0ce4cd4367685659d4fa2a0008a4d7"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/fx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fc62f4735409bc8ddc23a6d8f7acd14a68f99ab355fa730a92d5b4883dd497f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cb144c3990758d2e814f2b6b1a72e35b8e9b840c63972d0a54219981ffd79cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c320f5652ef66738ac2b8554349f8fca23cf6889de886df73055ccfc84898639"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e6cc8c1c4362db808f189b1023bb9004762860a9aba7ac58faa7fe63a733c34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62243ebc7dc24ccf724bd3e8cd39a00fab3bc5d1d387766496e445bb4481d722"
  end

  depends_on "zig" => :build

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fx --version")

    output = shell_output("#{bin}/fx ask hello 2>&1", 1)
    assert_match "Fx needs access to Vercel AI Gateway", output
  end
end
