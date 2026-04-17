class Treesearch < Formula
  desc "Structure-aware document search CLI. Fast keyword matching over hierarchical document trees."
  homepage "https://github.com/shibing624/TreeSearch"
  version "1.0.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shibing624/TreeSearch/releases/download/v1.0.8/treesearch-aarch64-apple-darwin.tar.xz"
      sha256 "1e280cd4e6c74c543e46b5dafce5ebfe06ab1c1670bbfe46856723ec6c118263"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shibing624/TreeSearch/releases/download/v1.0.8/treesearch-x86_64-apple-darwin.tar.xz"
      sha256 "ed5c2f37c7ddc4218bacdb1f6c8223ae71fc3d511406634fcef22ee78d1a5e21"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/shibing624/TreeSearch/releases/download/v1.0.8/treesearch-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "1295364831ffeb3f46611b469b59f86a95840b031f1b7827998f55144a03eded"
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "ts" if OS.mac? && Hardware::CPU.arm?
    bin.install "ts" if OS.mac? && Hardware::CPU.intel?
    bin.install "ts" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
