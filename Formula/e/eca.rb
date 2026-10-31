class Eca < Formula
  desc "Editor-agnostic AI pair programming assistant"
  homepage "https://eca.dev/"
  url "https://github.com/editor-code-assistant/eca/archive/refs/tags/0.169.0.tar.gz"
  sha256 "252c8825188e023cc79ea6c4121175b17ed37a20caa48d707c948f3330cd2cdf"
  license "Apache-2.0"
  head "https://github.com/editor-code-assistant/eca.git", branch: "master"

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
