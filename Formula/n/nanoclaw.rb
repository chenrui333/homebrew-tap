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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "3256d7e5a3be199f4071ace0e1adce6b6cacb70c808c7238bb2810695ba05e43"
    sha256 cellar: :any, arm64_sequoia: "8d9dedb4344ede9f8ddb550e60a0d99887c5602f3c117a3ed22aee926367d2d0"
    sha256 cellar: :any, arm64_linux:   "7a6ba762bd1ab2867fffe086af746b84ef5133c4934268b6577b33b9209a109e"
    sha256 cellar: :any, x86_64_linux:  "2275728479821f3537e7f070f051baf821fec5c8f18edbd3cacb9634d36dc7c3"
  end

  depends_on "node@24"

  deny_network_access!

  def fetch
    system formula_opt_bin("node@24")/"npm", "ci"
  end

  def install
    npm = formula_opt_bin("node@24")/"npm"
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

      exec "#{formula_opt_bin("node@24")}/node" "#{libexec}/dist/index.js" "$@"
    SH
    chmod 0755, bin/"nanoclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanoclaw --version")

    node_eval = <<~EOS
      import('#{libexec}/dist/index.js').then(() => console.log('load-ok'))
    EOS

    output = shell_output(
      "#{formula_opt_bin("node@24")}/node -e \"#{node_eval}\"",
    )
    assert_match "load-ok", output
  end
end
