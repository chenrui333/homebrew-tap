class Eca < Formula
  desc "Editor-agnostic AI pair programming assistant"
  homepage "https://eca.dev/"
  url "https://github.com/editor-code-assistant/eca/archive/refs/tags/141.0.tar.gz"
  sha256 "51616163930dfd9794f8437b526d386480bb83461984f6a18f6e3f10f2640f1e"
  license "Apache-2.0"
  head "https://github.com/editor-code-assistant/eca.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bc02d268b14de553736031609f7ed5887fca24e5fb80dd2b5e6d97237a04434"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0fa884f2c8c35b5b6be949e7853daca530a5bb64cd21696936e4afa0d32a765"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c35c3b0ccf372b30c149f547da653d61520b93501d659f22f75b5cce0c80239b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32e3ecc3472f3175f106f85a0430f7a38e7c622df5749f718b8ce64f283eee8a"
  end

  depends_on "clojure" => :build
  depends_on "openjdk"

  deny_network_access!

  def fetch
    system "clojure", "-P", "-M:native"
    system "clojure", "-P", "-T:build"
  end

  def install
    system "clojure", "-T:build", "prod-jar"
    libexec.install "target/eca.jar"
    (bin/"eca").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("openjdk")}/java" -jar "#{libexec}/eca.jar" "$@"
    SH
    chmod 0755, bin/"eca"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eca --version")
    # ECA's legacy chat cache uses Transit JSON, including keyword map keys.
    (testpath/"db.transit.json").write <<~JSON
      ["^ ","~:version",6,"~:chats",["^ ","brew-chat",["^ ","~:title","Offline chat","~:status","~:idle","~:model","test/model","~:created-at",0,"~:updated-at",0,"~:user-prompt-count",1,"~:messages",[["^ ","~:role","user","~:content","Hello Homebrew","~:content-id","m1","~:created-at",0]]]]]
    JSON
    output = shell_output("#{bin}/eca read-chat --db-cache-path #{testpath}/db.transit.json")
    chat = JSON.parse(output)
    assert_equal "brew-chat", chat.fetch("id")
    assert_equal "Offline chat", chat.fetch("title")
    output = shell_output("#{bin}/eca read-chat --db-cache-path #{testpath}/db.transit.json --chat-id brew-chat")
    assert_equal "Hello Homebrew", JSON.parse(output).fetch("content")
  end
end
