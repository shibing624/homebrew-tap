class Treesearch < Formula
  desc "Structure-aware document search CLI. Fast keyword matching over hierarchical document trees."
  homepage "https://github.com/shibing624/TreeSearch"
  version "1.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shibing624/TreeSearch/releases/download/v1.1.1/treesearch-aarch64-apple-darwin.tar.xz"
      sha256 "7ec798c9b451d841b62e3b4e0656a98a53dd9872ac3c9b61ead1537ea2a51cca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shibing624/TreeSearch/releases/download/v1.1.1/treesearch-x86_64-apple-darwin.tar.xz"
      sha256 "fda3f4541164b5a8c3ff9d614941ebac18c84619cd8944b3962f5e9837ef1753"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/shibing624/TreeSearch/releases/download/v1.1.1/treesearch-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0bc61962c18546051868c90eb72e453f7b43b7cb9c8012c85fa02553271db5c6"
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
