class Creanote < Formula
  desc "Create organized notes from the terminal"
  homepage "https://github.com/elitalpa/creanote"
  url "https://github.com/elitalpa/creanote/archive/refs/tags/creanote@0.3.2.tar.gz"
  sha256 "aa9280adc7a18adbe2c6f2442d6c0132334a91054a6e8482ec8acbc766fcfa25"
  license "MIT"
  head "https://github.com/elitalpa/creanote.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "62fc628b796436541b6686126ab54b717d9699ef624dc93176b7a303416eb2e4"
  end

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
    assert_match version.to_s, shell_output("#{bin}/creanote --version")

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
