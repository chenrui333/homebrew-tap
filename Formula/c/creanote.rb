class Creanote < Formula
  desc "Create organized notes from the terminal"
  homepage "https://github.com/elitalpa/creanote"
  url "https://github.com/elitalpa/creanote/archive/refs/tags/creanote@0.3.1.tar.gz"
  sha256 "f43387af07a8d3f1922e710d35c19944714e10e14fda24f31fad1dc3f44e43d6"
  license "MIT"
  head "https://github.com/elitalpa/creanote.git", branch: "main"

  depends_on "node"

  def install
    cd "packages/creanote" do
      system "npm", "install", "--include=dev", *std_npm_args(prefix: false, ignore_scripts: false)
      system "npm", "run", "build"
      system "npm", "install", *std_npm_args
    end

    bin.install_symlink libexec/"bin/creanote"
  end

  test do
    help_output = shell_output("#{bin}/creanote --help")
    assert_match "CLI tool for your notes", help_output

    (testpath/".creanote/templates").mkpath
    (testpath/".creanote/templates/note.md").write <<~TEXT
      # {{date}} note
    TEXT
    (testpath/".creanote/config.json").write <<~JSON
      {
        "info": {
          "name": "creanote",
          "author": "Homebrew",
          "url": "https://example.com",
          "license": "MIT"
        },
        "settings": {
          "basePath": "./",
          "templates": [
            {
              "name": "note",
              "description": "Regular note",
              "path": ".creanote/templates/note.md",
              "ext": "md",
              "target": "{{year}}-{{month}}-{{day}}.{{ext}}"
            }
          ]
        }
      }
    JSON

    output = shell_output("#{bin}/creanote add note --filename homebrew-test")
    assert_match "Regular note added: homebrew-test.md", output
    assert_path_exists testpath/"homebrew-test.md"
    assert_match "# ", (testpath/"homebrew-test.md").read
  end
end
