class Nanoclaw < Formula
  desc "Personal Claude assistant with container-isolated agents"
  homepage "https://nanoclaw.dev"
  url "https://github.com/qwibitai/nanoclaw/archive/226b520131fbdbdbd2758fbf6ae4b1a2b7cf680f.tar.gz"
  version "1.1.0"
  sha256 "006a3ed9365f587fde1ba28482893a283a3e204e4c7eab2e6043bd128b14e012"
  license "MIT"
  head "https://github.com/qwibitai/nanoclaw.git", branch: "main"

  depends_on "node@24"

  def install
    npm = Formula["node@24"].opt_bin/"npm"
    system npm, "ci"
    system npm, "run", "build"
    system npm, "prune", "--omit=dev"

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
