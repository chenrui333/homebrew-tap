# framework: clap
class Mirrord < Formula
  desc "Run local processes in the context of Kubernetes environment"
  homepage "https://mirrord.dev/"
  url "https://github.com/metalbear-co/mirrord/archive/refs/tags/3.144.0.tar.gz"
  sha256 "c927b2ca356c0f16b56e615e2990046bd6f985868e0b4890b934f941959849a0"
  license "MIT"
  head "https://github.com/metalbear-co/mirrord.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "mirrord/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nvrs --version")

    cp pkgshare/"nvrs.toml", testpath

    (testpath/"n_keyfile.toml").write <<~EOS
      keys = ["dummy_value"]
    EOS

    output = shell_output("#{bin}/nvrs")
    assert_match "comlink NONE -> 0.1.1", output
  end
end
