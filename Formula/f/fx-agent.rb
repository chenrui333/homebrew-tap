class FxAgent < Formula
  desc "Tiny, open, embeddable, native coding agent"
  homepage "https://fx.sh"
  url "https://github.com/vercel-labs/fx/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "82d1aefaf2eac25631307227ccd36405cc0ce4cd4367685659d4fa2a0008a4d7"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/fx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13dd11c672420def5114582ae53dfefda4b6aa72c740fe7a6fd8ee1cf944f51f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2293a70302f31cfac5d309538ab4b724381db0c242e8fb8126c24ac5d731265c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b843562ccd99ac304a0a74ad8fb10bd930854967703be8e102115e5bc3c587d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "936d3f6c67e4bc7945553fbb4dc0702bf0433ccc912dd31ff0ad0c908dbe03a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae2810ff594dd37e7216680bc168f293deda211c08b30fdf91778c8e3fdba90f"
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
