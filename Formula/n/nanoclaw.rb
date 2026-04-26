class Nanoclaw < Formula
  desc "Personal Claude assistant with container-isolated agents"
  homepage "https://nanoclaw.dev"
  url "https://github.com/qwibitai/nanoclaw/archive/226b520131fbdbdbd2758fbf6ae4b1a2b7cf680f.tar.gz"
  version "1.1.0"
  sha256 "006a3ed9365f587fde1ba28482893a283a3e204e4c7eab2e6043bd128b14e012"
  license "MIT"
  head "https://github.com/qwibitai/nanoclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "5eed76b3f8cdf7cca0448192aef923f4c14c8bb94d3cd1273724e57ea39c4059"
    sha256 cellar: :any,                 arm64_sequoia: "ee56c0175da9b9654fa642ddee01abf044666ba6552c825f9890978272ae6ae5"
    sha256 cellar: :any,                 arm64_sonoma:  "3bc56d3a37c14ef206542bf2c6cb285abfbce0b71aaa948a90fe80782c1800bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dca19e1d8898a9ebc948cf2b024e217b50e761e06007d256d752d371bf0c9832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed3e9959a2488037028f8ad7888cf8b8372644384a3dc4ac0f3e76a1510cfbca"
  end

  depends_on "node@24"

  def install
    npm = Formula["node@24"].opt_bin/"npm"
    system npm, "ci"
    system npm, "run", "build"
    system npm, "prune", "--omit=dev"
    rm_r Dir["node_modules/@img/*linuxmusl*"]

    libexec.install Dir["*"]

    (bin/"nanoclaw").write <<~SH
      #!/bin/bash
      if [[ "$1" == "--version" || "$1" == "version" ]]; then
        echo "#{version}"
        exit 0
      fi

      exec "#{Formula["node@24"].opt_bin}/node" "#{libexec}/dist/index.js" "$@"
    SH
    chmod 0755, bin/"nanoclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanoclaw --version")

    node_eval = <<~EOS
      import('#{libexec}/dist/index.js').then(() => console.log('load-ok'))
    EOS

    output = shell_output(
      "#{Formula["node@24"].opt_bin}/node -e \"#{node_eval}\"",
    )
    assert_match "load-ok", output
  end
end
