class Trellis < Formula
  desc "Engineering framework for AI coding workflows"
  homepage "https://github.com/mindfold-ai/Trellis"
  url "https://github.com/mindfold-ai/Trellis/archive/refs/tags/v0.6.17.tar.gz"
  sha256 "002db498d065d2468e069ef47dce9181628b7c2990a11c65d0d1eed32732eea7"
  license "AGPL-3.0-only"
  head "https://github.com/mindfold-ai/Trellis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9459535decd2db19f65a5467c4648e49abb95fbb0ea4d1738da83634d94bcc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df4223f38109e70eb5259f91fb6472ca4afbcc8c5877237e4304fb4692f141c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d282cb6583199810ff3e7a40472209d8c5e96fc6e321cb180ce04988323faa3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab93102b5d5b69aefb0528da3a28dc4d9204efc4f715e2e2d2c11c2836d724ee"
  end

  depends_on "pnpm" => :build
  depends_on "node"

  # pnpm downloads the locked workspace dependencies before compiling TypeScript.
  allow_network_access! :build

  def install
    ENV["HUSKY"] = "0"
    system "pnpm", "install", "--frozen-lockfile", "--ignore-scripts"
    system "pnpm", "--filter", "@mindfoldhq/trellis-core", "build"
    system "pnpm", "--filter", "@mindfoldhq/trellis", "build"
    system "pnpm", "--filter", "@mindfoldhq/trellis", "--prod", "--ignore-scripts",
           "deploy", "--legacy", libexec
    (bin/"trellis").write_env_script libexec/"bin/trellis.js", PATH: "#{formula_opt_bin("node")}:$PATH"
    bin.install_symlink bin/"trellis" => "tl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trellis --version")
    output = shell_output("#{bin}/trellis init --yes --claude --user brew --no-monorepo 2>&1", 1)
    assert_match "Run trellis from your project directory instead", output
    (testpath/"project").mkpath
    cd testpath/"project" do
      system "git", "init"
      system bin/"trellis", "init", "--yes", "--claude", "--user", "brew", "--no-monorepo"
      assert_path_exists Pathname.pwd/".trellis/workflow.md"
      assert_path_exists Pathname.pwd/".claude/commands"
    end
  end
end
