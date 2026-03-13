class Distill < Formula
  desc "Compress large CLI outputs into concise answers for LLMs"
  homepage "https://github.com/samuelfaj/distill"
  url "https://github.com/samuelfaj/distill/archive/4a3f17e365566be9c405be43ddc5142d90fcc643.tar.gz"
  version "1.4.0"
  sha256 "cb153d92ae9d0b9595383a2d11a15d4d07e72c4dcfd42a987832c1a218e4adb3"
  license "MIT"
  head "https://github.com/samuelfaj/distill.git", branch: "main"

  livecheck do
    skip "no tagged releases"
  end

  depends_on "chenrui333/tap/bun" => :build
  depends_on "node"

  def install
    bun = Formula["chenrui333/tap/bun"].opt_bin/"bun"
    node = Formula["node"].opt_bin/"node"

    system bun, "build", "src/cli.ts", "--outfile", "distill.mjs", "--target=node"

    libexec.install "distill.mjs"
    (bin/"distill").write <<~SH
      #!/bin/bash
      exec "#{node}" "#{libexec}/distill.mjs" "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/distill --version")

    set_output = shell_output("XDG_CONFIG_HOME=#{testpath} #{bin}/distill config provider ollama")
    assert_equal "provider=ollama\n", set_output
    assert_equal "ollama\n", shell_output("XDG_CONFIG_HOME=#{testpath} #{bin}/distill config provider")
    assert_match "\"provider\": \"ollama\"", (testpath/"distill/config.json").read
  end
end
