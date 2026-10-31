class Eca < Formula
  desc "Editor-agnostic AI pair programming assistant"
  homepage "https://eca.dev/"
  url "https://github.com/editor-code-assistant/eca/archive/refs/tags/141.0.tar.gz"
  sha256 "51616163930dfd9794f8437b526d386480bb83461984f6a18f6e3f10f2640f1e"
  license "Apache-2.0"
  head "https://github.com/editor-code-assistant/eca.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c653959e64ffc97cd16080ee6e0eec8891ff97842a2137a42442998b7d92908"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bd811c055460b28d4d6a67660c3d47cc19b66d81f9a4245054fd8af31891971"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2030cabaa70c9b968acd7382037014ff09574eb534b453ad41dd8c19d4b700a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "179caed5acb58459c61ecc4fbfd881fcf1b97e2216c4ac6390f7d02f8952fff5"
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
