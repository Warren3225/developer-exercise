class Main extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            data: [],
            currentPage: 1,
            quotesPerPage: 10,
            allQuotes: false,
            theme: 'all',
            searchBarValue: ''
        }

        this.handleClick = this.handleClick.bind(this)
        this.handleClickAllQuotes = this.handleClickAllQuotes.bind(this)
        this.handleClickTheme = this.handleClickTheme.bind(this)
        this.handleChange = this.handleChange.bind(this);
    }

    handleClick(e) {
        this.setState({ allQuotes: false })
        this.setState({
            currentPage: Number(e.target.id)
        })
    }

    handleClickAllQuotes(e) {
        this.setState({ allQuotes: !this.state.allQuotes })
    }

    handleClickTheme(e) {
        this.setState({ theme: e.target.value })
    }
    handleChange(e) {
        this.setState({ searchBarValue: e.target.value })
    }

    componentWillMount() {
        const url = 'https://gist.githubusercontent.com/anonymous/8f61a8733ed7fa41c4ea/raw/1e90fd2741bb6310582e3822f59927eb535f6c73/quotes.json';
        fetch(url)
            .then((response) => {
                if (response.status >= 400) {
                    throw new Error('Bad response from server');
                }
                return response.json();
            })
            .then((data) => {
                this.setState({ data })
            })
    }

    render() {
        let { data, currentPage, quotesPerPage } = this.state;

        data.forEach((object, i) => {
            object.Number = (i + 1).toString()
            return object;
        })

        data = data.filter(quote => {
            if (this.state.theme === 'all') {
                return quote;
            }
            else if (quote.theme === this.state.theme) {
                return quote;
            }
        }).filter(quote => quote.quote.includes(this.state.searchBarValue))


        const indexOfLastQuote = currentPage * quotesPerPage
        const indexofFirstQuote = indexOfLastQuote - quotesPerPage;
        const quotesOnPage = data.slice(indexofFirstQuote, indexOfLastQuote)

        const pageNumbers = [];
        for (let i = 1; i <= Math.ceil(data.length / quotesPerPage); i++) {
            pageNumbers.push(i);
        }

        const renderPageNumbers = pageNumbers.map(number => {
            return (
                <button
                    key={number}
                    id={number}
                    onClick={this.handleClick}
                >
                    {number}
                </button>
            );
        });

        let tableCategories = _.keys(data[0]).map(header => header[0].toUpperCase() + header.slice(1)).filter(word => word !== "Number").sort()
        tableCategories.unshift("Index")
        let tableHeaders = tableCategories.map((category, i) => <th key={i}>{category}</th>)

        let tableRows;

        if (!this.state.allQuotes) {
            tableRows = quotesOnPage.map(quote => {
                return (<tr key={quote.Number}>
                    <td>{quote.Number}</td>
                    <td>{quote.context}</td>
                    <td>{quote.quote}</td>
                    <td>{quote.source}</td>
                    <td>{quote.theme}</td>
                </tr>)
            })
        } else {
            tableRows = data.map(quote => {
                return (<tr key={quote.Number}>
                    <td>{quote.Number}</td>
                    <td>{quote.context}</td>
                    <td>{quote.quote}</td>
                    <td>{quote.source}</td>
                    <td>{quote.theme}</td>
                </tr>)
            })
        }
        return (
            <div>
                <form>
                    <input type='text' value={this.state.searchBarValue} placeholder="Filter by Quote Text" onChange={this.handleChange} />
                </form>
                <div id="table">
                    <h1>Quotes</h1>
                    <p>Filter by Theme: <button value="all" onClick={this.handleClickTheme}>All</button><button value="movies" onClick={this.handleClickTheme}>Movies</button><button value="games" onClick={this.handleClickTheme}>Games</button></p>
                    <table>
                        <tbody>
                            <tr>
                                {tableHeaders}
                            </tr>
                            {tableRows}
                        </tbody>
                    </table>
                    <div id="buttons">
                        {
                            (this.state.allQuotes === false ? <button onClick={this.handleClickAllQuotes}>Show All Quotes</button> : null)
                        }
                        <br />
                        {renderPageNumbers}
                    </div>
                </div>
            </div>
        )
    }
}

ReactDOM.render(
    <Main />,
    document.getElementById('quotes')
);