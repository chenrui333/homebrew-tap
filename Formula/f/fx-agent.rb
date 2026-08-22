class FxAgent < Formula
  desc "Tiny, open, embeddable, native coding agent"
  homepage "https://fx.sh"
  url "https://github.com/vercel-labs/fx/archive/refs/tags/v0.0.5.tar.gz"
  sha256 "f30e539ee943a5c70d3ba8d15f171e216798e0de368cf38eb7a90483e5eba582"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/fx.git", branch: "main"

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
